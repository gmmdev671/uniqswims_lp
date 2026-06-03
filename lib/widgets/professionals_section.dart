import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfessionalsSection extends StatelessWidget {
  final VoidCallback? onWorkWithUs;

  const ProfessionalsSection({super.key, this.onWorkWithUs});

  // Dados de exemplo — substitua URLs pelos corretos mais tarde
  final List<_ProfessionalItem> _professionals = const [
    _ProfessionalItem(
      name: 'Caik Bueno',
      role: 'Regional Manager',
      facebookUrl: 'https://facebook.com',
      instagramUrl: 'https://instagram.com',
    ),
    _ProfessionalItem(
      name: 'Danilo Bazzana',
      role: 'Licensee Holder',
      facebookUrl: 'https://facebook.com',
      instagramUrl: 'https://instagram.com',
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
              'Meet Our Professionals',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: _professionals.length,
              itemBuilder: (context, index, realIndex) {
                final p = _professionals[index];
                return _ProfessionalCard(
                  name: p.name,
                  role: p.role,
                  facebookUrl: p.facebookUrl,
                  instagramUrl: p.instagramUrl,
                );
              },
              options: CarouselOptions(
                viewportFraction: viewportFraction,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                height: 420,
                padEnds: false,
              ),
            ),
            const SizedBox(height: 28),
            // CTA: Work with us (rola para o formulário)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onWorkWithUs,
                icon: const Icon(Icons.arrow_right),
                label: const Text(
                  'Work with us',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  int _itemsForWidth(double width) {
    if (width < 600) return 1;
    if (width < 1000) return 2;
    return 3;
  }
}

class _ProfessionalCard extends StatelessWidget {
  final String name;
  final String role;
  final String facebookUrl;
  final String instagramUrl;

  const _ProfessionalCard({
    required this.name,
    required this.role,
    required this.facebookUrl,
    required this.instagramUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Card design similar to the layout you provided
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Column(
        children: [
          // Circular placeholder image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 72,
                color: Colors.black38,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            role,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebookF, size: 16),
                onPressed: () => _openLink(facebookUrl),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram, size: 18),
                onPressed: () => _openLink(instagramUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openLink(String url) async {
    try {
      await launchUrlString(url, webOnlyWindowName: '_blank');
    } catch (e) {
      // Opcional: lidar com erro (mostrar SnackBar, etc.)
      // ignore: avoid_print
      print('Could not open url: $url — $e');
    }
  }
}

class _ProfessionalItem {
  final String name;
  final String role;
  final String facebookUrl;
  final String instagramUrl;

  const _ProfessionalItem({
    required this.name,
    required this.role,
    required this.facebookUrl,
    required this.instagramUrl,
  });
}