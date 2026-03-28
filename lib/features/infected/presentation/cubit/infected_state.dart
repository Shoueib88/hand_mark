import 'package:equatable/equatable.dart';

class InfectedState extends Equatable {
  const InfectedState({
    this.isRecording = false,
    this.duration = const Duration(),
    this.playRemoteVideoUrl,
    this.snackbarError,
    this.snackbarSuccess,
    this.voicelistofdata = const [],
  });

  final bool isRecording;
  final Duration duration;
  final String? playRemoteVideoUrl;
  final String? snackbarError;
  final String? snackbarSuccess;
  final List voicelistofdata;

  InfectedState copyWith({
    bool? isRecording,
    Duration? duration,
    String? playRemoteVideoUrl,
    bool clearPlayRemoteVideoUrl = false,
    String? snackbarError,
    bool clearSnackbarError = false,
    String? snackbarSuccess,
    bool clearSnackbarSuccess = false,
    List? voicelistofdata,
  }) {
    return InfectedState(
      isRecording: isRecording ?? this.isRecording,
      duration: duration ?? this.duration,
      playRemoteVideoUrl: clearPlayRemoteVideoUrl
          ? null
          : (playRemoteVideoUrl ?? this.playRemoteVideoUrl),
      snackbarError:
          clearSnackbarError ? null : (snackbarError ?? this.snackbarError),
      snackbarSuccess: clearSnackbarSuccess
          ? null
          : (snackbarSuccess ?? this.snackbarSuccess),
      voicelistofdata: voicelistofdata ?? this.voicelistofdata,
    );
  }

  @override
  List<Object?> get props => [
        isRecording,
        duration,
        playRemoteVideoUrl,
        snackbarError,
        snackbarSuccess,
        voicelistofdata,
      ];
}
