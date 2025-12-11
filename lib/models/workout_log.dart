import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WorkoutLog extends Equatable {
  final String id;
  final String userId;
  final DateTime startTime;
  final int duration;
  final String workoutType;
  final int totalVolume;
  final String title; 
  final String description; 

  const WorkoutLog({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.duration,
    required this.workoutType,
    required this.totalVolume,
    required this.title,
    required this.description,
  });

  String get subtitle => '$duration min • $description';

  factory WorkoutLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return WorkoutLog(
      id: doc.id,
      userId: data['user_id'] ?? '',
      startTime: (data['start_time'] as Timestamp).toDate(),
      duration: data['duration'] ?? 0,
      workoutType: data['workout_type'] ?? 'Unknown',
      totalVolume: data['total_volume'] ?? 0,
      title: data['title'] ?? '${data['workout_type']} Session',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'start_time': Timestamp.fromDate(startTime),
      'duration': duration,
      'workout_type': workoutType,
      'total_volume': totalVolume,

      'title': title,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, userId, startTime, duration, workoutType, totalVolume, title, description];
}