import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String? backgroundImage;
  final Key? sectionKey; // key a ser passada para Scrollable.ensureVisible
  final VoidCallback? onContactPressed; // callback do CTA (opcional)

  const AboutSection({
    Key? key,
    this.backgroundImage,
    this.sectionKey,
    this.onContactPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 768;

      return Container(
        key: sectionKey, // <-- aqui a seção expõe a key para rolagem
        width: double.infinity,
        color: colorScheme.background,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 80,
          horizontal: isMobile ? 20 : 48,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile ? _buildColumn(context, colorScheme, textTheme) : _buildRow(context, colorScheme, textTheme),
        ),
      );
    });
  }

  Widget _buildRow(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: _buildImageCard(context, colorScheme)),
        const SizedBox(width: 40),
        Expanded(flex: 1, child: _buildTextContent(context, colorScheme, textTheme, TextAlign.left)),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImageCard(context, colorScheme),
        const SizedBox(height: 24),
        _buildTextContent(context, colorScheme, textTheme, TextAlign.center),
      ],
    );
  }

  Widget _buildImageCard(BuildContext context, ColorScheme colorScheme) {
    final hasImage = backgroundImage != null && backgroundImage!.isNotEmpty;

    return AspectRatio(
      aspectRatio: 9 / 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: colorScheme.surface,
          child: hasImage
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: backgroundImage!.startsWith('http')
                          ? NetworkImage(backgroundImage!) as ImageProvider
                          : AssetImage(backgroundImage!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.55),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.pool,
                    size: 56,
                    color: colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, TextAlign align) {
    return Column(
      crossAxisAlignment: align == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // barra pequena (underline)
        Align(
          alignment: align == TextAlign.left ? Alignment.centerLeft : Alignment.center,
          child: Container(
            width: 64,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            color: colorScheme.onSurface,
          ),
        ),

        Text(
          'Your Trusted\nPartner in Pool Care',
          textAlign: align,
          style: (textTheme.headlineMedium ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
              .copyWith(color: colorScheme.onSurface, height: 1.05),
        ),

        const SizedBox(height: 16),

        Text(
          'At UNIQ Swims, we believe your pool should be a haven of relaxation, not a source of concern. Our mission is to deliver exceptional pool and spa maintenance services, ensuring your aquatic spaces remain immaculate and inviting.',
          textAlign: align,
          style: (textTheme.bodyLarge ?? const TextStyle(fontSize: 16))
              .copyWith(color: colorScheme.onSurface.withOpacity(0.95), height: 1.6),
        ),

        const SizedBox(height: 18),

        Text(
          'From routine upkeep to expert repairs, our team provides dependable, professional care, ensuring your pool stays crystal clear and hassle-free so you can focus on enjoying the tranquility it brings.',
          textAlign: align,
          style: (textTheme.bodyMedium ?? const TextStyle(fontSize: 15))
              .copyWith(color: colorScheme.onSurface.withOpacity(0.8), height: 1.6),
        ),

        const SizedBox(height: 22),

        // CTA — chama o callback passado (se existir)
        Align(
          alignment: align == TextAlign.left ? Alignment.centerLeft : Alignment.center,
          child: OutlinedButton.icon(
            onPressed: onContactPressed,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Get In Touch'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}