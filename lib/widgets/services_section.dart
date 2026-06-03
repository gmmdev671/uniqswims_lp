import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  // Dados de exemplo — substitua pelos dados reais quando tiver
  final List<_ServiceItem> _services = const [
    _ServiceItem(
      title: 'Pool Maintenance',
      description:
          'Serviço completo de manutenção de piscinas — limpeza, química, inspeção e manutenção preventiva.',
    ),
    _ServiceItem(
      title: 'Pool Repairs',
      description:
          'Reparos especializados: bombas, filtros, vazamentos e revestimentos. Diagnóstico rápido e solução garantida.',
    ),
    _ServiceItem(
      title: 'Professional Licensing',
      description:
          'Apoio e consultoria para obtenção de licenças e formação profissional para técnicos e franqueados.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      final int itemsToShow = _itemsForWidth(maxWidth);
      final double viewportFraction = 1 / itemsToShow;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 2, endIndent: 300),
            const SizedBox(height: 12),
            const Text(
              'Our Services',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: _services.length,
              itemBuilder: (context, index, realIndex) {
                final service = _services[index];
                return _ServiceCard(
                  title: service.title,
                  description: service.description,
                  // placeholder widget for image
                  placeholder: _buildPlaceholderImage(context),
                );
              },
              options: CarouselOptions(
                viewportFraction: viewportFraction,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                // Adjust height responsively
                height: itemsToShow == 1 ? 300 : 360,
                padEnds: false,
              ),
            ),
          ],
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.black38,
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget placeholder;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    // Card internal padding + clickable to open modal
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDescriptionModal(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area (placeholder)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: placeholder,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDescriptionModal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(description)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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

  const _ServiceItem({
    required this.title,
    required this.description,
  });
}