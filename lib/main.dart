import 'package:flutter/material.dart';

// Importando widgets das seções
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/why_choose_widget.dart'; // Nova seção
import 'widgets/contact_section.dart';
import 'widgets/app_bar_hide.dart'; // AppBar que esconde ao rolar

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
  final GlobalKey _contactKey = GlobalKey(); // Para rolagem programática

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Função para rolar até a seção de contato
  void _scrollToContact() {
    final context = _contactKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HideableAppBar(
        scrollController: _scrollController,
        title: 'UniqSwims',
        actions: [
          IconButton(
            onPressed: _scrollToContact,
            icon: const Icon(Icons.email_outlined),
          ),
        ],
      ),
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
                  HeroSection(onContactPressed: _scrollToContact),
                  const AboutSection(),
                  const WhyChooseWidget(), // Nova seção adicionada
                  ContactSection(key: _contactKey), // Identificado para navegação
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}