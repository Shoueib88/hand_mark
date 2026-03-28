import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hand_mark/features/infected/data/services/send_voice_services.dart';
import 'package:hand_mark/features/infected/presentation/cubit/infected_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class InfectedCubit extends Cubit<InfectedState> {
  InfectedCubit() : super(const InfectedState()) {
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    _initializeRecorder();
    _initializePlayer();
  }

  late FlutterSoundRecorder _audioRecorder;
  late FlutterSoundPlayer _audioPlayer;
  String _audioFilePath = '';
  String _audiopath = 'no path';
  Duration _duration = const Duration();
  Timer? _timer;
  List _voicelistofdata = [];

  Future<void> _initializeRecorder() async {
    try {
      await _audioRecorder.openRecorder();
    } catch (e) {
      emit(state.copyWith(snackbarError: 'Error initializing recorder: $e'));
    }
  }

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayer.openPlayer();
    } catch (e) {
      emit(state.copyWith(snackbarError: 'Error initializing player: $e'));
    }
  }

  Future<void> startRecording() async {
    if (!state.isRecording) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        emit(state.copyWith(
            snackbarError:
                'Microphone permission is required to record audio'));
        return;
      }

      try {
        final directory = await getApplicationDocumentsDirectory();
        _audioFilePath = '${directory.path}/audio_file.m4a';
        await _audioRecorder.startRecorder(
          toFile: _audioFilePath,
          codec: Codec.aacMP4,
        );
        _duration = const Duration();
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _duration += const Duration(seconds: 1);
          emit(state.copyWith(
            isRecording: true,
            duration: _duration,
          ));
        });
        emit(state.copyWith(
          isRecording: true,
          duration: _duration,
        ));
      } catch (e) {
        emit(state.copyWith(snackbarError: 'Error starting recording: $e'));
      }
    }
  }

  Future<void> stopRecording() async {
    if (state.isRecording) {
      try {
        await _audioRecorder.stopRecorder();
        _timer?.cancel();
        _audiopath = _audioFilePath;
        emit(state.copyWith(
          isRecording: false,
        ));
        _voicelistofdata =
            await VoiceInfectedServices().voiceInfectedService(_audiopath);
        if (_voicelistofdata.isNotEmpty) {
          emit(state.copyWith(
            voicelistofdata: _voicelistofdata,
            playRemoteVideoUrl: '${_voicelistofdata[0]}',
          ));
        } else {
          emit(state.copyWith(
              snackbarError: 'No voice detected in the audio file',
              voicelistofdata: _voicelistofdata));
        }
        emit(state.copyWith(snackbarSuccess: 'Recording true'));
      } catch (e) {
        emit(state.copyWith(snackbarError: 'Error stopping recording: $e'));
        print('Error stopping recording: $e');
      }
    }
  }

  void clearSnackbarError() {
    emit(state.copyWith(clearSnackbarError: true));
  }

  void clearSnackbarSuccess() {
    emit(state.copyWith(clearSnackbarSuccess: true));
  }

  void consumePlayRequest() {
    emit(state.copyWith(clearPlayRemoteVideoUrl: true));
  }

  @override
  Future<void> close() {
    _audioRecorder.closeRecorder();
    _audioPlayer.closePlayer();
    _timer?.cancel();
    return super.close();
  }
}
