import 'package:flutter/material.dart';

// Importando widgets das seções
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/features_section.dart';
import 'widgets/contact_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniqSwims Landing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determina breakpoint responsivo
          bool isMobile = constraints.maxWidth < 768;
          double sidePadding = isMobile ? 16.0 : 48.0;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: Column(
                children: [
                  // Seções com widgets reais
                  const HeroSection(),
                  const AboutSection(),
                  const FeaturesSection(),
                  const ContactSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}