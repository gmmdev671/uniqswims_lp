import 'package:flutter/material.dart';

class WhyChooseWidget extends StatelessWidget {
  final Key? sectionKey;

  const WhyChooseWidget({Key? key, this.sectionKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final isMobile = MediaQuery.of(context).size.width < 768;

    final reasons = [
      {
        "icon": Icons.build_rounded,
        "title": "Specialized Maintenance",
        "desc":
            "We meticulously manage every aspect of your pool or spa, ensuring unparalleled attention to detail."
      },
      {
        "icon": Icons.star_border,
        "title": "Innovation and Exclusivity",
        "desc":
            "As pioneers of this business model in the Orlando area, we offer a distinctive solution tailored for both pool owners and aspiring professionals."
      },
      {
        "icon": Icons.card_membership,
        "title": "Professional Licensing",
        "desc":
            "Our comprehensive certification and training programs empower you to build a successful career in a promising industry."
      },
    ];

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: cs.background,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 36 : 80,
        horizontal: isMobile ? 20 : 48,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title + underline
            _buildTitle(cs, tt, isMobile),
            const SizedBox(height: 28),

            // Desktop: two columns (Commitment card | Reasons list)
            // Mobile: stacked (Commitment card then reasons)
            isMobile ? _buildMobileLayout(cs, tt, reasons) : _buildDesktopLayout(cs, tt, reasons),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ColorScheme cs, TextTheme tt, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // thin underline bar
        Container(
          width: 64,
          height: 4,
          color: cs.onSurface,
          margin: const EdgeInsets.only(bottom: 12),
        ),
        Text(
          'Why Choose\nUNIQ Swims?',
          style: (tt.displayLarge ?? tt.headlineMedium ?? const TextStyle(fontSize: 36, fontWeight: FontWeight.w800))
              .copyWith(color: cs.onSurface, height: 1.05),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(ColorScheme cs, TextTheme tt, List<Map<String, dynamic>> reasons) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //reasons list (styled like original)
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: reasons
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: _ListReasonItem(item: r, colorScheme: cs, textTheme: tt),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(width: 48),
        //Commitment card
        Expanded(
          flex: 5,
          child: _CommitmentCard(colorScheme: cs, textTheme: tt),
        ),
        
      ],
    );
  }

  Widget _buildMobileLayout(ColorScheme cs, TextTheme tt, List<Map<String, dynamic>> reasons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CommitmentCard(colorScheme: cs, textTheme: tt),
        const SizedBox(height: 28),
        ...reasons
            .map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: _ListReasonItem(item: r, colorScheme: cs, textTheme: tt),
                ))
            .toList(),
      ],
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _CommitmentCard({required this.colorScheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6)),
        ],
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Commitment\nto Excellence',
            style: (textTheme.headlineMedium ?? const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                .copyWith(color: colorScheme.onSurface, height: 1.05),
          ),
          const SizedBox(height: 12),
          Text(
            'At UNIQ Swims, we are dedicated to delivering unparalleled excellence, trust, and innovation in every aspect of our services. Whether maintaining your pool or assisting you in embarking on a new career path, our mission is to provide exceptional solutions that meet your unique needs.',
            style: (textTheme.bodyLarge ?? const TextStyle(fontSize: 16)).copyWith(
              color: colorScheme.onSurface.withOpacity(0.92),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListReasonItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ListReasonItem({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // circular outline icon (hollow circle with icon inside)
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: colorScheme.onSurface, width: 2),
          ),
          child: Center(
            child: Icon(
              item['icon'] as IconData,
              size: 20,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(width: 20),

        // texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String,
                style: (textTheme.titleLarge ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))
                    .copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 6),
              Text(
                item['desc'] as String,
                style: (textTheme.bodyMedium ?? const TextStyle(fontSize: 15)).copyWith(
                  color: colorScheme.onSurface.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}