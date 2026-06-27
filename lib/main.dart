import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniqswims_lp/shared/environment.dart';
import 'package:uniqswims_shared/uniqswims_shared.dart';
import 'package:uniqswims_lp/uniqswims_theme.dart';
import 'package:uniqswims_lp/shared/footer.dart';
import 'package:uniqswims_lp/features/home/widgets/professionals_section.dart';
import 'package:uniqswims_lp/features/home/widgets/services_section.dart';

// Importando widgets das seções
import 'features/home/widgets/hero_section.dart';
import 'features/home/widgets/about_section.dart';
import 'features/home/widgets/why_choose_widget.dart'; // Nova seção
import 'features/home/widgets/contact_section.dart';
import 'shared/app_bar_hide.dart'; // AppBar que esconde ao rolar
import 'features/home/widgets/testimonials_section.dart'; // NOVO WIDGET

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Environment.supabaseUrl,
    publishableKey: Environment.supabasePublishableKey,
  );

  SharedInject.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniqSwims Landing',
      debugShowCheckedModeBanner: false,
      theme: UniqSwimsTheme.darkTheme,
      home: const ResponsiveAppShell(),
    );
  }
}

class ResponsiveAppShell extends StatefulWidget {
  const ResponsiveAppShell({super.key});

  @override
  State<ResponsiveAppShell> createState() => _ResponsiveAppShellState();
}

class _ResponsiveAppShellState extends State<ResponsiveAppShell> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _whyChooseKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _professionalsKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Rola para a chave fornecida (se for null, rola ao topo)
  Future<void> _scrollToKey(GlobalKey? key) async {
    try {
      if (key == null) {
        await _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        return;
      }
      final ctx = key.currentContext;
      if (ctx == null) {
        // fallback: rola ao topo
        await _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        return;
      }
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    } catch (_) {
      // ignore errors silently (e.g., durante hot reload)
    }
  }

  // Mapeamento rótulo -> GlobalKey
  Map<String, GlobalKey?> get _navMap => {
        'Home': _heroKey,
        'About': _aboutKey,
        'Why Choose': _whyChooseKey,
        'Services': _servicesKey,
        'Professionals': _professionalsKey,
        'Testimonials': _testimonialsKey,
        'Contact': _contactKey,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textStyle = theme.textTheme.labelLarge?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w600, fontSize: 12);

    return Scaffold(
      appBar: HideableAppBar(
        scrollController: _scrollController,
        title: 'UniqSwims',
        // actions: usamos um LayoutBuilder para trocar entre menu popup (mobile) e botões (desktop)
        actions: [
          LayoutBuilder(builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 700;
            if (isNarrow) {
              // Mobile: popup menu
              return PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: cs.onSurface),
                onSelected: (label) {
                  final key = _navMap[label];
                  _scrollToKey(key);
                },
                itemBuilder: (ctx) => _navMap.keys
                    .map((label) => PopupMenuItem<String>(value: label, child: Text(label)))
                    .toList(),
              );
            } else {
              // Desktop: show as TextButtons
              return Row(
                children: _navMap.entries.map((entry) {
                  final label = entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextButton(
                      onPressed: () => _scrollToKey(entry.value),
                      style: TextButton.styleFrom(
                        foregroundColor: cs.onSurface,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      child: Text(label, style: textStyle),
                    ),
                  );
                }).toList(),
              );
            }
          }),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(sectionKey: _heroKey, onContactPressed: () => _scrollToKey(_contactKey)),
                AboutSection(backgroundImage: 'assets/images/about.jpeg', sectionKey: _aboutKey, onContactPressed: () => _scrollToKey(_contactKey)),
                WhyChooseWidget(sectionKey: _whyChooseKey),
                ServicesSection(sectionKey: _servicesKey),
                ProfessionalsSection(sectionKey: _professionalsKey),
                TestimonialsSection(sectionKey: _testimonialsKey),
                ContactSection(sectionKey: _contactKey, onSubmit: (data) async {
                  // exemplo: rolar para topo da seção de contato após submit
                  await Future.delayed(const Duration(milliseconds: 200));
                  _scrollToKey(_contactKey);
                }),
                Footer(
                  internalActions: {
                    'Contact': () => _scrollToKey(_contactKey),
                  },
                  socialLinksOverride: {
                    'facebook': 'https://facebook.com/sua_pagina',
                    'instagram': 'https://instagram.com/sua_pagina',
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}