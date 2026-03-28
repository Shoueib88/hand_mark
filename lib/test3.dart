import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_mark/core/constants/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import 'package:hand_mark/features/infected/data/services/send_text_services.dart';

class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  List? _textlistofdata;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('asset/video/defult_.mp4')
          ..initialize().then((value) {
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: 3 / 2,
              autoInitialize: true,
              autoPlay: true,
              looping: true,
            );
            setState(() {});
          });
  }

  _sendtextToApi(String value) async {
    print('77777777777777777777777777777777777777777777777777777777777');
    print('>>>>>>> $value');
    // Send the input value to the local host API

    _textlistofdata = (await TextInfectedServices().textInfectedService(value));
    print('77777777777777777777777777777777777777777777777777777777777');
    print(_textlistofdata);

    // Replace with your API call
    if (_textlistofdata!.isEmpty) {
      downloadAndPlayVideo(_textlistofdata![0]);
    } else {
      print('No text detected');
      print('77777777777777777777777777777777777777777777777777777777777');
      print(_textlistofdata);
    }
  }

  Future<void> downloadAndPlayVideo(String videoUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/video.mp4');

    await http.get(Uri.parse(videoUrl)).then((response) {
      file.writeAsBytesSync(response.bodyBytes);
    });
    print('££££££££££££££££££££££££ $file');
    _videoPlayerController = VideoPlayerController.file(file);
    await _videoPlayerController.initialize().then((value) {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: 3 / 2,
          autoInitialize: true,
          autoPlay: true,
          looping: true);
    });
    await _videoPlayerController.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          children: [
            _videoPlayerController.value.isInitialized
                ? Container(
                    color: S.primaryColor.withOpacity(0.19),
                    width: MediaQuery.of(context).size.width,
                    height: 370.h,
                    child: VideoPlay(
                        videoPlayerController: _videoPlayerController,
                        chewieController: _chewieController),
                  )
                : const Text('No video selected'),
            ElevatedButton(
                onPressed: () async {
                  await _sendtextToApi('شعيب');
                },
                child: const Text('select')),
          ],
        ),
      ),
    );
  }
}

class VideoPlay extends StatefulWidget {
  const VideoPlay(
      {super.key,
      required this.videoPlayerController,
      required this.chewieController});
  final VideoPlayerController videoPlayerController;
  final ChewieController chewieController;

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  @override
  Widget build(BuildContext context) {
    return widget.videoPlayerController.value.isInitialized
        ? Chewie(controller: widget.chewieController)
        : const CircularProgressIndicator();
  }
}
