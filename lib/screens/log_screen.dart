import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Вже не потрібен тут

import '../utils/constants.dart';
// import '../models/workout_log.dart'; // Вже не потрібен тут
import '../widgets/workout_card.dart';
import '../blocs/log_bloc/log_bloc.dart';
import '../blocs/log_bloc/log_event.dart';
import '../blocs/log_bloc/log_state.dart';
import '../services/workout_repository.dart';
import 'log_details_screen.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogBloc(repository: WorkoutRepository())..add(LoadLogs()),
      child: const LogScreenView(),
    );
  }
}

class LogScreenView extends StatelessWidget {
  const LogScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Review your past sessions",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              "Workout History",
              style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        // ❌ ПРИБРАЛИ ACTIONS (Кнопку +)
      ),

      body: SafeArea(
        child: BlocBuilder<LogBloc, LogState>(
          builder: (context, state) {
            if (state is LogLoading) {
              return const Center(child: CircularProgressIndicator(color: kSecondaryColor));
            }

            if (state is LogError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }

            if (state is LogLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  _buildCalendarStrip(context, state.selectedDate),
                  
                  const SizedBox(height: 20),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Workouts on ${DateFormat('MMM d').format(state.selectedDate)}",
                      style: const TextStyle(color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Expanded(
                    child: state.logs.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: state.logs.length,
                            itemBuilder: (context, index) {
                              final log = state.logs[index];
                              
                              return Dismissible(
                                key: Key(log.id),
                                direction: DismissDirection.startToEnd, 
                                background: Container(
                                  alignment: Alignment.centerLeft, 
                                  padding: const EdgeInsets.only(left: 20), 
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  context.read<LogBloc>().add(DeleteWorkout(log.id));
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${log.title} deleted")),
                                  );
                                },
                                child: WorkoutCard(
                                  log: log,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogDetailsScreen(log: log),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ❌ ПРИБРАЛИ МЕТОД _showAddWorkoutDialog

  Widget _buildCalendarStrip(BuildContext context, DateTime selectedDate) {
    // (Код календаря залишається без змін, він досить великий, тому я його скоротив тут для зручності читання. 
    // Якщо ти його не копіювала собі окремо, скажи, я надам повну версію файлу ще раз).
    final startDate = selectedDate.subtract(const Duration(days: 3));
    final weekDates = List.generate(7, (index) => startDate.add(Duration(days: index)));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: kInputFillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(selectedDate),
                style: const TextStyle(color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios, color: kTextColor, size: 16),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDates.map((date) {
              final isSelected = date.day == selectedDate.day && 
                                 date.month == selectedDate.month &&
                                 date.year == selectedDate.year;
              
              return GestureDetector(
                onTap: () {
                  context.read<LogBloc>().add(SelectDate(date));
                },
                child: Column(
                  children: [
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        color: kTextColor.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? kSecondaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? null : Border.all(color: Colors.transparent),
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: kTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? kSecondaryColor : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: kTextColor.withValues(alpha: 0.2)),
          const SizedBox(height: 10),
          Text(
            "No workouts this day",
            style: TextStyle(color: kTextColor.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}