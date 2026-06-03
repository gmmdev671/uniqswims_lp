import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isMobile) {
            return Column(
              children: [
                Image.asset(
                  "assets/images/about_placeholder.png",
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                _buildTextContent(),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/about_placeholder.png",
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(flex: 1, child: _buildTextContent()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTextContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Us",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "At UniqSwims, we believe in empowering athletes with gear that performs as hard as they do. Our products combine cutting-edge technology with elegant design to elevate your swimming experience.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}