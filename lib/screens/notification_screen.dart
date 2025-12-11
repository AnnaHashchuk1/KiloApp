import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kInputFillColor, 
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: kTextColor.withAlpha(178)), // Колір кнопки "Назад"
      ),
      body: Center(
        child: Text(
          'Your notifications will appear here!',
          style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 18),
        ),
      ),
    );
  }
}
