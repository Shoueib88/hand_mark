import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {super.key,
      required this.videoPlayerController,
      required this.chewieController});
  final VideoPlayerController videoPlayerController;
  final ChewieController chewieController;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.videoPlayerController.value.isInitialized
        ? Chewie(controller: widget.chewieController)
        : const CircularProgressIndicator();
  }
}
