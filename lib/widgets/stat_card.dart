import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kInputFillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: kSecondaryColor.withAlpha(178), size: 24),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: kTextColor, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
