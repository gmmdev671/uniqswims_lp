import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestimonialsSection extends StatelessWidget {
  final List<Map<String, String>> testimonials = [
    {
      'text': 'Excelente serviço! Super recomendo.',
      'name': 'João Silva',
      'image': 'assets/images/joao.jpg',
    },
    {
      'text': 'Atendimento rápido e profissional.',
      'name': 'Maria Oliveira',
      'image': 'assets/images/maria.jpg',
    },
    {
      'text': 'Produto de alta qualidade!',
      'name': 'Carlos Souza',
      'image': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          Text(
            "O que nossos clientes dizem",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CarouselSlider.builder(
            itemCount: testimonials.length,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              enableInfiniteScroll: true,
            ),
            itemBuilder: (context, index, realIndex) {
              final testimonial = testimonials[index];
              return _buildTestimonialCard(testimonial);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Map<String, String> testimonial) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              testimonial['text']!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (testimonial['image']!.isNotEmpty)
                  CircleAvatar(
                    backgroundImage: AssetImage(testimonial['image']!),
                    radius: 20,
                  )
                else
                  const CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 20,
                  ),
                const SizedBox(width: 10),
                Text(
                  testimonial['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}