import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/workout_repository.dart';
import 'log_event.dart';
import 'log_state.dart';
import '../../models/workout_log.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final WorkoutRepository _repository;
  List<WorkoutLog> _allFetchedLogs = [];

  LogBloc({required WorkoutRepository repository}) 
      : _repository = repository, 
        super(LogLoading()) {
    on<LoadLogs>(_onLoadLogs);
    on<SelectDate>(_onSelectDate);
    on<AddWorkout>(_onAddWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<UpdateWorkout>(_onUpdateWorkout);
  }

  Future<void> _onLoadLogs(LoadLogs event, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      _allFetchedLogs = await _repository.getWorkouts();
      final today = DateTime.now();
      final logsForToday = _filterLogsByDate(today);
      emit(LogLoaded(logs: logsForToday, selectedDate: today));
    } catch (e) {
      emit(LogError("Не вдалося завантажити дані: ${e.toString()}"));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<LogState> emit) {
    if (state is LogLoaded || state is LogError) {
      final filteredLogs = _filterLogsByDate(event.selectedDate);
      emit(LogLoaded(logs: filteredLogs, selectedDate: event.selectedDate));
    }
  }

  Future<void> _onAddWorkout(AddWorkout event, Emitter<LogState> emit) async {
    emit(LogLoading()); 
    try {
      await _repository.addWorkout(event.workout);
      _allFetchedLogs = await _repository.getWorkouts();
      final logsForDate = _filterLogsByDate(event.workout.startTime);
      emit(LogLoaded(logs: logsForDate, selectedDate: event.workout.startTime));
    } catch (e) {
      emit(LogError("Помилка додавання: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteWorkout(DeleteWorkout event, Emitter<LogState> emit) async {
    try {
      await _repository.deleteWorkout(event.workoutId);
      _allFetchedLogs.removeWhere((log) => log.id == event.workoutId);
      if (state is LogLoaded) {
        final currentSelectedDate = (state as LogLoaded).selectedDate;
        final logsForDate = _filterLogsByDate(currentSelectedDate);
        emit(LogLoaded(logs: logsForDate, selectedDate: currentSelectedDate));
      }
    } catch (e) {
      emit(LogError("Помилка видалення: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateWorkout(UpdateWorkout event, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      await _repository.updateWorkout(event.workout);
      _allFetchedLogs = await _repository.getWorkouts();
      final logsForDate = _filterLogsByDate(event.workout.startTime);
      emit(LogLoaded(logs: logsForDate, selectedDate: event.workout.startTime));
    } catch (e) {
      emit(LogError("Помилка оновлення: ${e.toString()}"));
    }
  }

  List<WorkoutLog> _filterLogsByDate(DateTime date) {
    return _allFetchedLogs.where((log) {
      return log.startTime.year == date.year &&
             log.startTime.month == date.month &&
             log.startTime.day == date.day;
    }).toList();
  }
}