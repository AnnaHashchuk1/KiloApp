import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_log.dart';

class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<WorkoutLog>> getWorkouts() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('sessions')
          .where('user_id', isEqualTo: userId)
          .orderBy('start_time', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WorkoutLog.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching workouts: $e');
    }
  }

  Future<void> addWorkout(WorkoutLog workout) async {
    try {
      await _firestore.collection('sessions').add(workout.toFirestore());
    } catch (e) {
      throw Exception('Error adding workout: $e');
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _firestore.collection('sessions').doc(workoutId).delete();
    } catch (e) {
      throw Exception('Error deleting workout: $e');
    }
  }

  Future<void> updateWorkout(WorkoutLog workout) async {
    try {
      await _firestore.collection('sessions').doc(workout.id).update(workout.toFirestore());
    } catch (e) {
      throw Exception('Error updating workout: $e');
    }
  }
}