import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
