import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  final bool compact;

  // Mapa opcional: rótulo -> callback (ex.: scroll para seção)
  final Map<String, VoidCallback>? internalActions;

  // Se fornecido, substitui os social links internos do widget (key -> url)
  final Map<String, String>? socialLinksOverride;

  // Link do "made by" (se null usa o link do exemplo)
  final String? madeByUrl;

  const Footer({
    Key? key,
    this.compact = false,
    this.internalActions,
    this.socialLinksOverride,
    this.madeByUrl,
  }) : super(key: key);

  // Rótulos internos padrão
  static const Map<String, String> _internalLinks = {
    'Sobre': '/about',
    'Serviços': '/services',
    'Clientes': '/clients',
    'Missão': '/mission',
    'Licenciamento': '/licensing',
    'Contato': '/contact',
  };

  // Social links padrão (substituível por socialLinksOverride)
  static const Map<String, String> _defaultSocialLinks = {
    'facebook': 'https://facebook.com/yourpage',
    'instagram': 'https://instagram.com/yourpage',
  };

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // ignore errors silently — caller can provide links corretos
    }
  }

  Object _iconFor(String name) {
    switch (name.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebookF;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'linkedin':
        return FontAwesomeIcons.linkedinIn;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      default:
        return FontAwesomeIcons.globe;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final padding = compact ? 12.0 : 24.0;
    final socialLinks = socialLinksOverride ?? _defaultSocialLinks;
    final madeUrl = madeByUrl ?? 'https://gabrielmoraisdev.com.br/';

    return Container(
      color: cs.surface,
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 1.5),
      child: LayoutBuilder(builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        final textColor = cs.onSurface;
        final smallTextStyle = tt.bodySmall?.copyWith(color: textColor.withOpacity(0.85)) ??
            TextStyle(color: textColor.withOpacity(0.85), fontSize: compact ? 12 : 14);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // Top area: descrição | links internos | social
            Flex(
              direction: isNarrow ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                // Descrição (esquerda)
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(right: isNarrow ? 0 : 24.0, bottom: isNarrow ? 12 : 0),
                    child: Text(
                      'We are committed to delivering exceptional services, prioritizing customer satisfaction and upholding the highest safety standards.',
                      style: smallTextStyle.copyWith(height: 1.5),
                      textAlign: isNarrow ? TextAlign.center : TextAlign.start,
                    ),
                  ),
                ),

                SizedBox(width: isNarrow ? 0 : 16, height: isNarrow ? 12 : 0),

                // Links internos
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Text('Company', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: compact ? 13 : 16)),
                      SizedBox(height: 8),
                      Wrap(
                        alignment: isNarrow ? WrapAlignment.center : WrapAlignment.start,
                        spacing: 16,
                        runSpacing: 8,
                        children: _internalLinks.entries.map((entry) {
                          return InkWell(
                            onTap: () {
                              if (internalActions != null && internalActions!.containsKey(entry.key)) {
                                internalActions![entry.key]!();
                                return;
                              }
                              // Fallback: rota nomeada (se começar com '/')
                              if (entry.value.startsWith('/')) {
                                try {
                                  Navigator.of(context).pushNamed(entry.value);
                                } catch (_) {}
                              }
                            },
                            child: Text(entry.key, style: smallTextStyle.copyWith(decoration: TextDecoration.underline)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: isNarrow ? 0 : 24, height: isNarrow ? 12 : 0),

                // Social
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Text('Social Media', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: compact ? 13 : 16)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: socialLinks.entries.map((s) {
                          final rawIcon = _iconFor(s.key);
                          final Widget iconWidget;

                          if (rawIcon is IconData) {
                            // cobre IconData padrão (inclui Icons.*)
                            iconWidget = Icon(rawIcon, color: textColor, size: compact ? 16 : 18);
                          } else {
                            // assume que é FaIconData (ou equivalente) — renderiza com FaIcon
                            iconWidget = FaIcon(rawIcon as dynamic, color: textColor, size: compact ? 16 : 18);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              onPressed: () => _openUrl(s.value),
                              icon: iconWidget,
                              tooltip: s.key,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(color: textColor.withOpacity(0.12), height: 1),
            SizedBox(height: 12),

            // Copyright / made by
            Flex(
              direction: isNarrow ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: isNarrow ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '© ${DateTime.now().year} UniqSwims. Todos os direitos reservados.',
                  style: smallTextStyle.copyWith(fontSize: compact ? 11 : 13),
                ),

                // spacer on desktop
                if (!isNarrow) const SizedBox(width: 12),

                // Made with Flutter + portfolio link
                Padding(
                  padding: EdgeInsets.only(top: isNarrow ? 8.0 : 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _openUrl(madeUrl),
                        child: Text(
                          'Feito com Flutter • Gabriel Morais',
                          style: smallTextStyle.copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('• Termos e Condições', style: smallTextStyle),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}