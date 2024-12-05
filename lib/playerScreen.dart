import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final bool fullscreen;

  VideoPlayerScreen({required this.videoPath, required this.fullscreen});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void fullscreen(isFullScreen) {
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play Video"),
      ),
      body: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(children: [
                VideoPlayer(_controller),
                Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.fullscreen))),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      icon: Icon(_controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow)),
                )
              ]),
            )
          : CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
    );
  }
}
