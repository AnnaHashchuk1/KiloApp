import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_log.dart';
import '../utils/constants.dart';
import 'add_activity_screen.dart'; // Імпорт екрану редагування

class LogDetailsScreen extends StatelessWidget {
  final WorkoutLog log;

  const LogDetailsScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM d, y').format(log.startTime);
    final IconData icon = log.workoutType == 'Strength' 
        ? Icons.fitness_center 
        : Icons.directions_run;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Workout Details", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: kSecondaryColor, size: 48),
              ),
            ),
            const SizedBox(height: 32),
            Text(log.title, style: const TextStyle(color: kTextColor, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Text(formattedDate, style: TextStyle(color: kTextColor.withValues(alpha: 0.7), fontSize: 16)),
              ],
            ),
            const SizedBox(height: 32),
            _buildDetailSection("Summary", log.subtitle),
            const SizedBox(height: 24),
            // Показуємо реальний опис
            _buildDetailSection("Notes", log.description.isNotEmpty ? log.description : "No additional notes."),
            
            const SizedBox(height: 40),
            
            // ✅ КНОПКА EDIT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Перехід на AddActivityScreen у режимі редагування
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddActivityScreen(workoutToEdit: log),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kInputFillColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Edit Entry",
                  style: TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: kSecondaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(12)),
          child: Text(content, style: const TextStyle(color: kTextColor, fontSize: 16, height: 1.5)),
        ),
      ],
    );
  }
}