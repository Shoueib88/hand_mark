import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'package:hand_mark/features/not_infected/data/services/not_infected_services.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(
        '/data/user/0/com.example.hand_mark/cache/file_picker/1717731062451/VID-20240607-WA0000.mp4'))
      ..initialize().then((value) {
        setState(() {});
      });
  }

  File? _video;
  String _videoPathFromApi = '';
  String filepath = '';
  List getalldata = [];
  Future<void> _selectVideo() async {
    FilePickerResult? result;

    result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    filepath = result!.files.first.path!;

    print(filepath + '>>>>>>>>>>>>>>>>>>>>>>>>');
    getalldata = await InfectedServices().infectedService(filepath);
    setState(() {
      if (result != null) {
        _video = File(result.files.first.path!);
        _videoPathFromApi = getalldata[0];
        print('444444444444444444444444 $getalldata');
        print('444444444444444444444444 $_videoPathFromApi');
        print('444444444444444444444444 $_video');
        downloadAndPlayVideo(_videoPathFromApi);
      } else {
        _video = null;
      }
    });
  }

  Future<void> downloadAndPlayVideo(String videoUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/video.mp4');

    await http.get(Uri.parse(videoUrl)).then((response) {
      file.writeAsBytesSync(response.bodyBytes);
    });
    print('££££££££££££££££££££££££ $file');
    _videoPlayerController = VideoPlayerController.file(file);
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : const Text('No video selected'),
            SizedBox(height: 90.h),
            FloatingActionButton(
              onPressed: _selectVideo,
              tooltip: 'Select Video',
              child: const Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {super.key,
      // required this.videoPath,
      required this.videoPlayerController});
  // final String videoPath;
  final VideoPlayerController videoPlayerController;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const CircularProgressIndicator();
  }
}
