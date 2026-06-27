import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfessionalsSection extends StatelessWidget {
  final Key? sectionKey;
  final VoidCallback? onWorkWithUs;

  const ProfessionalsSection({Key? key, this.sectionKey, this.onWorkWithUs}) : super(key: key);

  // Dados de exemplo — substitua URLs e imagens pelos reais
  final List<_ProfessionalItem> _professionals = const [
    _ProfessionalItem(
      name: 'Caik Bueno',
      role: 'Regional Manager',
      facebookUrl: 'https://facebook.com',
      instagramUrl: 'https://instagram.com',
      // imageUrl: 'https://example.com/caik.jpg',
    ),
    _ProfessionalItem(
      name: 'Danilo Bazzana',
      role: 'Licensee Holder',
      facebookUrl: 'https://facebook.com',
      instagramUrl: 'https://instagram.com',
      // imageUrl: 'https://example.com/danilo.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      final bool isMobile = maxWidth < 600;
      final int itemsToShow = _itemsForWidth(maxWidth);

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
              // underline + title
              Container(width: 64, height: 4, color: cs.onSurface, margin: const EdgeInsets.only(bottom: 12)),
              Text(
                'Meet Our Professionals',
                style: (tt.headlineMedium ?? const TextStyle(fontSize: 34, fontWeight: FontWeight.bold))
                    .copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: 20),

              // For wide screens show a grid; else use Carousel
              if (maxWidth >= 1000)
                _buildGrid(context, cs, tt)
              else
                CarouselSlider.builder(
                  itemCount: _professionals.length,
                  itemBuilder: (context, index, realIndex) {
                    final p = _professionals[index];
                    return _ProfessionalCard(
                      item: p,
                      colorScheme: cs,
                      textTheme: tt,
                    );
                  },
                  options: CarouselOptions(
                    viewportFraction: 1 / itemsToShow,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    height: 420,
                    padEnds: false,
                  ),
                ),

              const SizedBox(height: 48),

              // CTA: Work with us
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'Do you want to be next?',
                      style: (const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                    const SizedBox(height: 15,),
                    OutlinedButton.icon(
                      onPressed: onWorkWithUs,
                      icon: const Icon(Icons.arrow_right),
                      label: Text(
                        'Professional Licensing',
                        style: (tt.labelLarge ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                            .copyWith(color: cs.onSurface),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: cs.onSurface.withOpacity(0.6)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGrid(BuildContext context, ColorScheme cs, TextTheme tt) {
    // show two columns for professionals on wide screens
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _professionals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 380,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemBuilder: (context, idx) {
        final p = _professionals[idx];
        return _ProfessionalCard(item: p, colorScheme: cs, textTheme: tt);
      },
    );
  }

  int _itemsForWidth(double width) {
    if (width < 600) return 1;
    if (width < 1000) return 2;
    return 3;
  }
}

class _ProfessionalCard extends StatelessWidget {
  final _ProfessionalItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ProfessionalCard({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme;
    final tt = textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.onSurface.withOpacity(0.04)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular photo with white background like the reference
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // white circular background
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // photo (if available) or placeholder icon
                  ClipOval(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: item.imageUrl != null
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                              child: Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, err, st) => _placeholderIcon(cs),
                              ),
                            )
                          : _placeholderIcon(cs),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              item.name,
              style: (tt.titleLarge ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))
                  .copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              item.role,
              style: (tt.bodyMedium ?? const TextStyle(fontSize: 14)).copyWith(color: cs.onSurface.withOpacity(0.75)),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Social icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIconButton(icon: FontAwesomeIcons.facebookF, url: item.facebookUrl, colorScheme: cs),
                const SizedBox(width: 12),
                _socialIconButton(icon: FontAwesomeIcons.instagram, url: item.instagramUrl, colorScheme: cs),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon(ColorScheme cs) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Icon(
          Icons.person,
          size: 72,
          color: cs.onSurface.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _socialIconButton({
    required Object? icon,
    required String url,
    required ColorScheme colorScheme,
  }) {
    // Se o ícone for um IconData (inclui FontAwesomeIcons.*), renderiza com Icon
    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(
        icon,
        size: 14,
        color: colorScheme.onSurface,
      );
    } else {
      // fallback seguro (sem ícone)
      iconWidget = const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _openLink(url),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.onSurface.withOpacity(0.9), width: 1.2),
          color: Colors.transparent,
        ),
        child: Center(child: iconWidget),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    try {
      await launchUrlString(url, webOnlyWindowName: '_blank');
    } catch (e) {
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
  final String? imageUrl;

  const _ProfessionalItem({
    required this.name,
    required this.role,
    required this.facebookUrl,
    required this.instagramUrl,
    this.imageUrl,
  });
}