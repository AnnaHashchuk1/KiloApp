import 'package:equatable/equatable.dart';
import '../../models/workout_log.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object> get props => [];
}

class LoadLogs extends LogEvent {}

class SelectDate extends LogEvent {
  final DateTime selectedDate;
  const SelectDate(this.selectedDate);
  @override
  List<Object> get props => [selectedDate];
}

class AddWorkout extends LogEvent {
  final WorkoutLog workout;
  const AddWorkout(this.workout);
  @override
  List<Object> get props => [workout];
}

class DeleteWorkout extends LogEvent {
  final String workoutId;
  const DeleteWorkout(this.workoutId);
  @override
  List<Object> get props => [workoutId];
}

class UpdateWorkout extends LogEvent {
  final WorkoutLog workout;
  const UpdateWorkout(this.workout);
  @override
  List<Object> get props => [workout];
}