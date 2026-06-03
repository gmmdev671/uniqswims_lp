import 'package:flutter/material.dart';

class WhyChooseWidget extends StatelessWidget {
  const WhyChooseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 600;

    List<Map<String, String>> reasons = [
      {"title": "High Performance Fabric", "desc": "Engineered for speed and comfort"},
      {"title": "Sustainable Materials", "desc": "Eco-friendly and durable"},
      {"title": "Tailored Fit", "desc": "Designed for every body type"},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFF5F9FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Why Choose UniqSwims?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          if (isMobile)
            Column(
              children: [
                _buildCommitmentCard(),
                const SizedBox(height: 20),
                ...reasons.map((item) => _buildReasonItem(item)).toList(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCommitmentCard()),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: reasons
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildReasonItem(item),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCommitmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Commitment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "We are trusted by professional swimmers and fitness enthusiasts worldwide.",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonItem(Map<String, String> item) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            item["desc"]!,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}