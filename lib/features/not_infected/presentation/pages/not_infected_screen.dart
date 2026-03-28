import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_mark/core/constants/style.dart';
import 'package:hand_mark/features/not_infected/presentation/cubit/not_infected_cubit.dart';
import 'package:hand_mark/features/not_infected/presentation/cubit/not_infected_state.dart';
import 'package:hand_mark/features/not_infected/presentation/widgets/not_infected_video_player_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class NotInfectedScreen extends StatefulWidget {
  const NotInfectedScreen({super.key});

  @override
  _NotInfectedScreenState createState() => _NotInfectedScreenState();
}

class _NotInfectedScreenState extends State<NotInfectedScreen> {
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
              errorBuilder: (context, errorMessage) {
                // Handle video playback error
                print('//////////// $errorMessage');
                return Center(
                  child: Text(
                    '********Error playing video: $errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            );
            setState(() {});
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
    await _videoPlayerController.initialize().then((value) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 3 / 2,
        autoInitialize: true,
        autoPlay: true,
        looping: true,
        errorBuilder: (context, errorMessage) {
          // Handle video playback error
          print('//////////// $errorMessage');
          return Center(
            child: Text(
              '*********Error playing video: $errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      );
    });
    await _videoPlayerController.play();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotInfectedCubit, NotInfectedState>(
      listenWhen: (p, c) =>
          c.playRemoteVideoUrl != null &&
          c.playRemoteVideoUrl != p.playRemoteVideoUrl,
      listener: (context, state) {
        final url = state.playRemoteVideoUrl;
        if (url != null) {
          downloadAndPlayVideo(url);
          context.read<NotInfectedCubit>().consumePlayRequest();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Not Infected'),
            centerTitle: true,
          ),
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                _videoPlayerController.value.isInitialized
                    ? Container(
                        color: S.primaryColor.withOpacity(0.19),
                        width: MediaQuery.of(context).size.width,
                        height: 400.h,
                        child: VideoPlayerScreen(
                            videoPlayerController: _videoPlayerController,
                            chewieController: _chewieController),
                      )
                    : const Text('No video selected'),
                SizedBox(height: 50.h),
                Container(
                    width: 65.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                        color: S.primaryColor,
                        borderRadius: BorderRadius.circular(13.r)),
                    child: Center(
                      child: MaterialButton(
                          onPressed: () => context
                              .read<NotInfectedCubit>()
                              .selectVideo(),
                          child: const Icon(Icons.camera)),
                    ))
              ]))),
    );
  }
}
