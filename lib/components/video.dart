import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String url;
  const VideoApp({super.key,required this.url});

  @override
  // ignore: library_private_types_in_public_api
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true); // Enable video looping
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controller.value.isInitialized
            ? SizedBox(
                height: 300,
                width: 300,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container(),
        const SizedBox(height: 16), // Add spacing between video and buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted;
                  _controller.setVolume(_isMuted ? 0.0 : 1.0);
                });
              },
              child: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
              ),
            ),
            const SizedBox(width: 16), // Add spacing between buttons
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
