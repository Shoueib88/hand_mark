import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_mark/features/not_infected/data/services/not_infected_services.dart';
import 'package:hand_mark/features/not_infected/presentation/cubit/not_infected_state.dart';
import 'package:image_picker/image_picker.dart';

class NotInfectedCubit extends Cubit<NotInfectedState> {
  NotInfectedCubit() : super(const NotInfectedState());

  File? _video;
  String _videoPathFromApi = '';
  String _filepath = '';
  List _getalldata = [];

  Future<void> selectVideo() async {
    XFile? result;
    result = await ImagePicker().pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 4));
    if (result != null) {
      _filepath = result.path;
    } else {
      _filepath =
          '/data/user/0/com.example.hand_mark/cache/file_picker/1719132197609/VID-20240613-WA0030.mp4';
    }

    print('$_filepath>>>>>>>>>>>>>>>>>>>>>>>>');
    _getalldata = await InfectedServices().infectedService(result!.path);
    _video = File(result.path);
    _videoPathFromApi = _getalldata[0];
    print('444444444444444444444444 $_getalldata');
    print('444444444444444444444444 $_videoPathFromApi');
    print('444444444444444444444444 $_video');
    emit(state.copyWith(playRemoteVideoUrl: _videoPathFromApi));
  }

  void consumePlayRequest() {
    emit(state.copyWith(clearPlayRemoteVideoUrl: true));
  }
}
