import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_mark/core/constants/style.dart';
import 'package:hand_mark/features/infected/presentation/cubit/infected_cubit.dart';
import 'package:hand_mark/features/infected/presentation/cubit/infected_state.dart';
import 'package:hand_mark/features/infected/presentation/widgets/infected_video_play.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class InfectedScreen extends StatefulWidget {
  const InfectedScreen({super.key});

  @override
  _InfectedScreenState createState() => _InfectedScreenState();
}

class _InfectedScreenState extends State<InfectedScreen> {
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

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.green))),
    );
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
    return MultiBlocListener(
      listeners: [
        BlocListener<InfectedCubit, InfectedState>(
          listenWhen: (p, c) =>
              c.snackbarError != null && c.snackbarError != p.snackbarError,
          listener: (context, state) {
            _showErrorSnackBar(state.snackbarError!);
            context.read<InfectedCubit>().clearSnackbarError();
          },
        ),
        BlocListener<InfectedCubit, InfectedState>(
          listenWhen: (p, c) =>
              c.snackbarSuccess != null &&
              c.snackbarSuccess != p.snackbarSuccess,
          listener: (context, state) {
            _showSuccessSnackBar(state.snackbarSuccess!);
            context.read<InfectedCubit>().clearSnackbarSuccess();
          },
        ),
        BlocListener<InfectedCubit, InfectedState>(
          listenWhen: (p, c) =>
              c.playRemoteVideoUrl != null &&
              c.playRemoteVideoUrl != p.playRemoteVideoUrl,
          listener: (context, state) {
            final url = state.playRemoteVideoUrl;
            if (url != null) {
              downloadAndPlayVideo(url);
              context.read<InfectedCubit>().consumePlayRequest();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Infected'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
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
            BlocBuilder<InfectedCubit, InfectedState>(
              buildWhen: (p, c) =>
                  p.isRecording != c.isRecording || p.duration != c.duration,
              builder: (context, state) {
                return Text(
                  state.isRecording ? _formatDuration(state.duration) : '',
                  style: const TextStyle(fontSize: 22),
                );
              },
            ),
            SizedBox(height: 50.h),
            BlocBuilder<InfectedCubit, InfectedState>(
              buildWhen: (p, c) => p.isRecording != c.isRecording,
              builder: (context, state) {
                return Container(
                    width: 65.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                        color: S.primaryColor,
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                        child: InkWell(
                            onTap: state.isRecording
                                ? () =>
                                    context.read<InfectedCubit>().stopRecording()
                                : () => context
                                    .read<InfectedCubit>()
                                    .startRecording(),
                            child: Icon(
                              state.isRecording ? Icons.stop : Icons.mic,
                              size: 48,
                              color:
                                  state.isRecording ? Colors.red : Colors.black,
                            ))));
              },
            ),
          ])),
        ),
      ),
    );
  }
}
