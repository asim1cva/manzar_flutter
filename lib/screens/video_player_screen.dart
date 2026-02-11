import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manzar_flutter/models/channel.dart';
import 'package:manzar_flutter/controllers/playlist_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Channel channel;

  const VideoPlayerScreen({super.key, required this.channel});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  int _aspectRatioIndex = 0;
  final List<double?> _aspectRatios = [null, 16 / 9, 4 / 3];
  final List<String> _aspectRatioLabels = ['Actual', '16:9', '4:3'];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    // Add to history
    Get.find<PlaylistController>().addToHistory(widget.channel);
  }

  Future<void> _initializePlayer() async {
    debugPrint('Initializing player for: ${widget.channel.name}');
    debugPrint('URL: ${widget.channel.url}');

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.channel.url),
        httpHeaders: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': '*/*',
          'Accept-Language': 'en-US,en;q=0.9',
          'Connection': 'keep-alive',
          'Icy-MetaData': '1',
          'Origin': 'https://google.com',
          'X-Forwarded-For': '8.8.8.8', // Fake global IP
        },
      );

      _videoPlayerController!.addListener(() {
        if (_videoPlayerController!.value.hasError) {
          debugPrint(
            'Video Player Controller Error: ${_videoPlayerController!.value.errorDescription}',
          );
        }
      });

      await _videoPlayerController!.initialize();
      debugPrint('Video initialized successfully');

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: true,
        looping: false,
        errorBuilder: (context, errorMessage) {
          debugPrint('Chewie Error: $errorMessage');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Playback Error: $errorMessage\n\nTry another channel if this persists.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white24,
        ),
        placeholder: const Center(child: CircularProgressIndicator()),
        fullScreenByDefault: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
      );
    } catch (e, stack) {
      debugPrint('Initialization Error: $e');
      debugPrint('Stack Trace: $stack');
      _errorMessage = e.toString().contains('401')
          ? 'Error 401: Unauthorized.\nThis stream requires a token or has expired.\nPlease try another channel.'
          : 'Error loading video: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleAspectRatio() {
    setState(() {
      _aspectRatioIndex = (_aspectRatioIndex + 1) % _aspectRatios.length;
      _chewieController?.dispose();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio:
            _aspectRatios[_aspectRatioIndex] ??
            _videoPlayerController!.value.aspectRatio,
        autoPlay: true,
        looping: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white24,
        ),
        placeholder: const Center(child: CircularProgressIndicator()),
        fullScreenByDefault: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.channel.name),
        backgroundColor: Colors.black45,
        elevation: 0,
        actions: [
          if (_chewieController != null)
            TextButton.icon(
              onPressed: _toggleAspectRatio,
              icon: const Icon(Icons.aspect_ratio, color: Colors.white),
              label: Text(
                _aspectRatioLabels[_aspectRatioIndex],
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      _initializePlayer();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              )
            : _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
            ? SafeArea(child: Chewie(controller: _chewieController!))
            : const Text(
                'Failed to initialize player',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
