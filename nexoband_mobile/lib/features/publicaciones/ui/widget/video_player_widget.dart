import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoCtrl;
  ChewieController? _chewieCtrl;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _videoCtrl.initialize();

      _chewieCtrl = ChewieController(
        videoPlayerController: _videoCtrl,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFFC7E39),
          handleColor: const Color(0xFFF13B57),
          bufferedColor: const Color(0xFF4A4A4A),
          backgroundColor: const Color(0xFF2C2B29),
        ),
        placeholder: Container(color: const Color(0xFF2C2B29)),
        errorBuilder: (context, msg) => Center(
          child: Text(msg, style: const TextStyle(color: Colors.white54)),
        ),
      );

      if (mounted) setState(() => _cargando = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar el vídeo';
          _cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieCtrl?.dispose();
    _videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2B29),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFef365b), size: 20),
            const SizedBox(width: 8),
            Text(_error!, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      );
    }

    if (_cargando) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2B29),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFC7E39)),
        ),
      );
    }

    final aspectRatio = _videoCtrl.value.aspectRatio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: aspectRatio > 0 ? aspectRatio : 16 / 9,
        child: Chewie(controller: _chewieCtrl!),
      ),
    );
  }
}
