import 'package:flutter_test/flutter_test.dart';
// Змініть імпорт 'exercise_tracker' на назву вашого проекту, якщо вона інша
import 'package:exercise_tracker/main.dart'; 

void main() {
  // Назва тесту, який відповідає вашому додатку
  testWidgets('App starts and displays Login Screen', (WidgetTester tester) async {
    // 1. Запускаємо наш головний віджет KiloApp
    await tester.pumpWidget(const KiloApp()); 

    // 2. Чекаємо на повну прорисовку (на випадок анімацій/віджетів)
    await tester.pumpAndSettle();

    // 3. Перевіряємо, чи відображаються ключові елементи LoginScreen
    expect(find.text('Welcome Back'), findsOneWidget); // Заголовок
    expect(find.text('Login'), findsOneWidget);       // Основна кнопка

    // Перевіряємо, чи є два поля для вводу (Email та Password)
    expect(find.text('Email'), findsOneWidget); 
    expect(find.text('Password'), findsOneWidget); 
    
    // Переконаємося, що ми не бачимо елементів старої Counter App
    // (наприклад, початкового тексту "You have pushed the button this many times:")
    expect(find.text('You have pushed the button this many times:'), findsNothing);
  });
}