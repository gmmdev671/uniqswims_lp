import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onContactPressed;
  final Key? sectionKey;

  const HeroSection({
    Key? key,
    required this.onContactPressed,
    this.sectionKey,
  }) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset(
        'assets/videos/pool_web.mp4',
      );

      await _controller!.initialize();
      // autoplay muted para browsers permitirem autoplay na web
      _controller!
        ..setVolume(0.0)
        ..setLooping(true)
        ..play();

      if (!mounted) return;
      setState(() {
        _videoReady = true;
        _videoFailed = false;
      });
    } catch (e, st) {
      // Log para debug
      debugPrint('Video init failed: $e\n$st');
      // Marca como falha e mantém o app renderizando o conteúdo (fallback)
      if (mounted) {
        setState(() {
          _videoReady = false;
          _videoFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildVideoOrFallback(BuildContext context, double height) {
    if (_videoReady && _controller != null && _controller!.value.isInitialized) {
      // Melhor usar FittedBox+SizedBox para BoxFit.cover
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    // Fallback: imagem estática (melhor) ou cor sólida
    // Assegure que 'assets/images/hero_placeholder.jpg' está no pubspec e na pasta
    return Image.asset(
      'assets/images/pool_placeholder.jpg',
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 768;
      final double sectionHeight =
          isMobile ? 640 : (MediaQuery.of(context).size.height * 0.85).clamp(560.0, 900.0);

      return SizedBox(
        key: widget.sectionKey,
        width: double.infinity,
        height: sectionHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: video ou fallback
            Positioned.fill(child: _buildVideoOrFallback(context, sectionHeight)),

            // Overlay de gradiente (para legibilidade)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: isMobile ? Alignment.topCenter : Alignment.centerLeft,
                    end: isMobile ? Alignment.bottomCenter : Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
            ),

            // Conteúdo
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 40 : 80,
                horizontal: isMobile ? 24 : 48,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isMobile) const Expanded(child: SizedBox()),
                      Expanded(
                        flex: isMobile ? 0 : 6,
                        child: Align(
                          alignment: isMobile ? Alignment.center : Alignment.centerRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                            children: [
                              Text(
                                'A NEW CONCEPT\nFOR POOL CARE',
                                textAlign: isMobile ? TextAlign.center : TextAlign.right,
                                style: (textTheme.displayLarge ??
                                        const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                        ))
                                    .copyWith(
                                  color: Colors.white,
                                  height: 1.05,
                                  letterSpacing: -1.0,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: isMobile ? 560 : 520),
                                child: Text(
                                  'At UNIQ Swims, we transcend traditional maintenance by offering an unparalleled commitment to care and precision.',
                                  textAlign: isMobile ? TextAlign.center : TextAlign.right,
                                  style: (textTheme.bodyLarge ?? const TextStyle(fontSize: 18))
                                      .copyWith(color: Colors.white, height: 1.6),
                                ),
                              ),
                              const SizedBox(height: 28),
                              OutlinedButton(
                                onPressed: widget.onContactPressed,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white, width: 1.5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 16),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('Get In Touch'),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}