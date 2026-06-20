import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  final Key? sectionKey;

  const ServicesSection({Key? key, this.sectionKey}) : super(key: key);

  // Dados de exemplo — substitua pelos dados reais quando tiver
  final List<_ServiceItem> _services = const [
    _ServiceItem(
      title: 'Pool Maintenance',
      description:
          'Serviço completo de manutenção de piscinas — limpeza, química, inspeção e manutenção preventiva.',
      imagePath: 'assets/images/services1.jpeg',
    ),
    _ServiceItem(
      title: 'Pool Repairs',
      description:
          'Reparos especializados: bombas, filtros, vazamentos e revestimentos. Diagnóstico rápido e solução garantida.',
      imagePath: 'assets/images/services1.jpeg',
    ),
    _ServiceItem(
      title: 'Professional Licensing',
      description:
          'Apoio e consultoria para obtenção de licenças e formação profissional para técnicos e franqueados.',
      imagePath: 'assets/images/services1.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final itemsToShow = _itemsForWidth(maxWidth);
      final viewportFraction = 1 / itemsToShow;
      final isMobile = maxWidth < 600;

      return Container(
        key: sectionKey,
        width: double.infinity,
        color: cs.background,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 36 : 72,
          horizontal: isMobile ? 20 : 48,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // small underline + title
              Container(
                width: 64,
                height: 4,
                color: cs.onSurface,
                margin: const EdgeInsets.only(bottom: 12),
              ),
              Text(
                'Our Services',
                style: (tt.headlineMedium ?? const TextStyle(fontSize: 34, fontWeight: FontWeight.bold))
                    .copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: 20),

              // Carousel
              CarouselSlider.builder(
                itemCount: _services.length,
                itemBuilder: (context, index, realIndex) {
                  final service = _services[index];
                  return _ServiceCard(
                    title: service.title,
                    description: service.description,
                    imagePath: service.imagePath, // passando path
                    colorScheme: cs,
                    textTheme: tt,
                  );
                },
                options: CarouselOptions(
                  viewportFraction: viewportFraction,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  height: itemsToShow == 1 ? 340 : 380,
                  padEnds: false,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  int _itemsForWidth(double width) {
    if (width < 600) return 1; // Mobile
    if (width < 1000) return 2; // Tablet / small desktop
    return 3; // Large desktop
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
          child: Container(
            color: cs.surface, // fallback color
            child: const Center(
              child: Icon(
                Icons.image,
                size: 48,
                color: Colors.white24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath; // agora é o path do asset
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDescriptionModal(context),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.onSurface.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6)),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildImage(imagePath), // método abaixo
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: (textTheme.titleLarge ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))
                    .copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: (textTheme.bodyMedium ?? const TextStyle(fontSize: 14))
                    .copyWith(color: colorScheme.onSurface.withOpacity(0.85), height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String cardImgPath) {
    // Uso simples com fallback se asset não existir
    return Image.asset(
      cardImgPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // fallback visual se não encontrar o asset
        return Container(
          color: colorScheme.surface,
          child: const Center(child: Icon(Icons.broken_image, color: Colors.white24, size: 48)),
        );
      },
    );
  }

  void _showDescriptionModal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final tt = Theme.of(context).textTheme;
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(title, style: tt.titleLarge?.copyWith(color: colorScheme.onSurface)),
          content: SingleChildScrollView(
            child: Text(description, style: tt.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.9))),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: tt.labelLarge?.copyWith(color: colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceItem {
  final String title;
  final String description;
  final String imagePath;

  const _ServiceItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}