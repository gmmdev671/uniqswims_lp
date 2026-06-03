import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      color: Colors.blue[100],
      child: const Center(child: Text('Hero Section')),
    );
  }
}