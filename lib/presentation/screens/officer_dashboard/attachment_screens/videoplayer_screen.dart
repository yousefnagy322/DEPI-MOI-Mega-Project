import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideo;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideo = _controller.initialize().then((_) {
      setState(() {}); // rebuild
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() => _showControls = false);
    });
  }

  void _seekForward(int seconds) {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    _controller.seekTo(
      position + Duration(seconds: seconds) > duration
          ? duration
          : position + Duration(seconds: seconds),
    );
  }

  void _seekBackward(int seconds) {
    final position = _controller.value.position;
    _controller.seekTo(
      position - Duration(seconds: seconds) < Duration.zero
          ? Duration.zero
          : position - Duration(seconds: seconds),
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),

                    // Buffering indicator
                    if (_controller.value.isBuffering)
                      const Center(child: CircularProgressIndicator()),

                    // Play/pause overlay
                    if (_showControls)
                      Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white.withOpacity(0.7),
                        size: 80,
                      ),

                    // Skip backward 10s
                    if (_showControls)
                      Positioned(
                        left: 30,
                        child: IconButton(
                          iconSize: 50,
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white70,
                          ),
                          onPressed: () => _seekBackward(10),
                        ),
                      ),

                    // Skip forward 30s
                    if (_showControls)
                      Positioned(
                        right: 30,
                        child: IconButton(
                          iconSize: 50,
                          icon: const Icon(
                            Icons.forward_30,
                            color: Colors.white70,
                          ),
                          onPressed: () => _seekForward(30),
                        ),
                      ),

                    // Progress bar
                    Positioned(
                      bottom: 20,
                      left: 10,
                      right: 10,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        colors: const VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
