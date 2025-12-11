import 'package:equatable/equatable.dart';
import '../../models/workout_log.dart';

abstract class LogState extends Equatable {
  const LogState();
  
  @override
  List<Object> get props => [];
}

class LogLoading extends LogState {}

class LogLoaded extends LogState {
  final List<WorkoutLog> logs;
  final DateTime selectedDate;

  const LogLoaded({
    required this.logs,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [logs, selectedDate];
}

class LogError extends LogState {
  final String message;

  const LogError(this.message);

  @override
  List<Object> get props => [message];
}