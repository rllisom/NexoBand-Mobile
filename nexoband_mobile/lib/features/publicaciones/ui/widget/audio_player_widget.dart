import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioPlayer _player;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setUrl(widget.url);
      if (mounted) setState(() => _cargando = false);
    } catch (e) {
      if (mounted) setState(() {
        _error = 'No se pudo cargar el audio';
        _cargando = false;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '0:00';
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2B29),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ── Barra de progreso ──────────────────────────────
          StreamBuilder<Duration?>(
            stream: _player.durationStream,
            builder: (context, durationSnap) {
              final total = durationSnap.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (context, posSnap) {
                  final pos = posSnap.data ?? Duration.zero;
                  final progreso =
                      total.inMilliseconds > 0
                          ? (pos.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0)
                          : 0.0;
                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 12),
                          activeTrackColor: const Color(0xFFFC7E39),
                          inactiveTrackColor: const Color(0xFF4A4A4A),
                          thumbColor: const Color(0xFFFC7E39),
                          overlayColor: const Color(0x33FC7E39),
                        ),
                        child: Slider(
                          value: progreso,
                          onChanged: _cargando
                              ? null
                              : (v) => _player.seek(
                                    Duration(
                                      milliseconds:
                                          (v * total.inMilliseconds).round(),
                                    ),
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(pos),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 11),
                            ),
                            Text(
                              _formatDuration(total),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // ── Controles ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Retroceder 10 s
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white70),
                onPressed: _cargando
                    ? null
                    : () => _player.seek(
                          Duration(
                            seconds:
                                (_player.position.inSeconds - 10).clamp(0, double.maxFinite.toInt()),
                          ),
                        ),
              ),
              // Play / Pause
              _cargando
                  ? const SizedBox(
                      width: 44,
                      height: 44,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          color: Color(0xFFFC7E39), strokeWidth: 2),
                      ),
                    )
                  : StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snap) {
                        final playing = snap.data?.playing ?? false;
                        final completed =
                            snap.data?.processingState == ProcessingState.completed;
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 28,
                            icon: Icon(
                              completed
                                  ? Icons.replay
                                  : playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (completed) {
                                _player.seek(Duration.zero);
                                _player.play();
                              } else if (playing) {
                                _player.pause();
                              } else {
                                _player.play();
                              }
                            },
                          ),
                        );
                      },
                    ),
              // Adelantar 10 s
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white70),
                onPressed: _cargando
                    ? null
                    : () {
                        final total = _player.duration?.inSeconds ?? 0;
                        _player.seek(
                          Duration(
                            seconds: (_player.position.inSeconds + 10)
                                .clamp(0, total),
                          ),
                        );
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
