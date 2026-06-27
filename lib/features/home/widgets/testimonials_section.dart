import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestimonialsSection extends StatelessWidget {
  final Key? sectionKey;

  // Se preferir, você pode passar essa lista pelo construtor.
  final List<Map<String, String>> testimonials = const [
    {
      'text': 'Excelente serviço! Super recomendo.',
      'name': 'João Silva',
      'image': 'assets/images/joao.jpg',
    },
    {
      'text': 'Atendimento rápido e profissional.',
      'name': 'Maria Oliveira',
      'image': 'assets/images/maria.jpg',
    },
    {
      'text': 'Produto de alta qualidade!',
      'name': 'Carlos Souza',
      'image': '',
    },
  ];

  TestimonialsSection({Key? key, this.sectionKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final isMobile = maxWidth < 600;
      final carouselHeight = isMobile ? 260.0 : 340.0;

      return Container(
        key: sectionKey,
        width: double.infinity,
        color: cs.background,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 28 : 64,
          horizontal: isMobile ? 20 : 48,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // small underline + title
              Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 64, height: 4, color: cs.onSurface, margin: const EdgeInsets.only(bottom: 12)),
              ),
              Text(
                "O que nossos clientes dizem",
                style: (tt.headlineMedium ?? const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                    .copyWith(color: cs.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              CarouselSlider.builder(
                itemCount: testimonials.length,
                itemBuilder: (context, index, realIndex) {
                  final testimonial = testimonials[index];
                  return _buildTestimonialCard(context, testimonial, cs, tt);
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  height: carouselHeight,
                  enableInfiniteScroll: true,
                  viewportFraction: isMobile ? 0.9 : 0.6,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTestimonialCard(BuildContext context, Map<String, String> testimonial, ColorScheme cs, TextTheme tt) {
    final text = testimonial['text'] ?? '';
    final name = testimonial['name'] ?? '';
    final image = testimonial['image'] ?? '';

    return Center(
      child: Container(
        width:  (MediaQuery.of(context).size.width < 1000) ? double.infinity : 720,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.onSurface.withOpacity(0.04)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Testimonial text
            Text(
              text,
              style: (tt.bodyLarge ?? const TextStyle(fontSize: 16)).copyWith(color: cs.onSurface.withOpacity(0.95), height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // author row
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image.isNotEmpty) ...[
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: _buildImageProvider(image, cs),
                      ),
                    ),
                  ),
                ] else ...[
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: cs.onSurface, size: 22),
                  ),
                ],
                const SizedBox(width: 12),
                Text(
                  name,
                  style: (tt.titleMedium ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                      .copyWith(color: cs.onSurface),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProvider(String pathOrUrl, ColorScheme cs) {
    // Suporta assets (caminho relativo sem http) e URLs remotas
    if (pathOrUrl.startsWith('http')) {
      return Image.network(
        pathOrUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: cs.surface, child: Icon(Icons.person, color: cs.onSurface)),
      );
    } else {
      return Image.asset(
        pathOrUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: cs.surface, child: Icon(Icons.person, color: cs.onSurface)),
      );
    }
  }
}