import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../utils/constants.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutLog log;
  final VoidCallback onTap;

  const WorkoutCard({
    super.key,
    required this.log,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ЗМІНА: Перевіряємо рядок, а не Enum
    // В базі ми писали "Strength" або "Cardio" (з великої літери)
    final IconData icon = log.workoutType == 'Strength' 
        ? Icons.fitness_center 
        : Icons.directions_run;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kInputFillColor,
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            left: BorderSide(color: kSecondaryColor, width: 4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: kSecondaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Використовуємо геттери з моделі (title, subtitle)
                  Text(
                    log.title, 
                    style: const TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    log.subtitle,
                    style: TextStyle(color: kTextColor.withValues(alpha: 0.6), fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: kTextColor.withValues(alpha: 0.4), size: 16),
          ],
        ),
      ),
    );
  }
}