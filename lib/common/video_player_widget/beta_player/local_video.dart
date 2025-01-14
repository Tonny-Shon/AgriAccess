import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class LocalVideoScreen extends StatefulWidget {
  final String videoUrl;

  const LocalVideoScreen({super.key, required this.videoUrl});

  @override
  State<LocalVideoScreen> createState() => _LocalVideoScreenState();
}

class _LocalVideoScreenState extends State<LocalVideoScreen> {
  BetterPlayerController? _betterPlayerController;
  bool _isVideoLoadingFailed = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.videoUrl,
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
      ),
      betterPlayerDataSource: dataSource,
    );

    _betterPlayerController!.addEventsListener(_handleVideoEvent);
  }

  void _handleVideoEvent(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      setState(() {
        _isVideoLoadingFailed = true;
      });
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.removeEventsListener(_handleVideoEvent);
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoLoadingFailed
        ? const Center(
            child: Text(
              'Failed to load video. Please try again later.',
              style: TextStyle(color: Colors.red),
            ),
          )
        : SizedBox(
            height: 200,
            child: BetterPlayer(controller: _betterPlayerController!),
          );
  }
}
