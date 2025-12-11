import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_log.dart';
import '../services/workout_repository.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class AddActivityScreen extends StatefulWidget {
  final WorkoutLog? workoutToEdit;

  const AddActivityScreen({super.key, this.workoutToEdit});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _volumeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Strength';
  bool _isLoading = false;

  final WorkoutRepository _repository = WorkoutRepository();

  bool get _isEditing => widget.workoutToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final w = widget.workoutToEdit!;
      _titleController.text = w.title;
      _descriptionController.text = w.description;
      _durationController.text = w.duration.toString();
      _volumeController.text = w.totalVolume.toString();
      _selectedDate = w.startTime;
      _selectedType = w.workoutType;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kSecondaryColor,
              onPrimary: kTextColor,
              surface: kInputFillColor,
              onSurface: kTextColor,
            ), dialogTheme: DialogThemeData(backgroundColor: kPrimaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveWorkout() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? '';
      final userName = user?.displayName ?? 'User';

      final duration = int.tryParse(_durationController.text) ?? 0;
      final volume = int.tryParse(_volumeController.text) ?? 0;

      final workout = WorkoutLog(
        id: _isEditing ? widget.workoutToEdit!.id : '',
        userId: userId,
        startTime: _selectedDate,
        duration: duration,
        workoutType: _selectedType,
        totalVolume: volume,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (_isEditing) {
        await _repository.updateWorkout(workout);
      } else {
        await _repository.addWorkout(workout);
      }

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: userName),
          ),
          (Route<dynamic> route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Workout updated!' : 'Workout added!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(_isEditing ? 'Edit Activity' : 'New Activity', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Workout Title", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: kTextColor),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "e.g. Morning Run",
                  hintStyle: TextStyle(color: kTextColor.withValues(alpha: 0.3)),
                  filled: true,
                  fillColor: kInputFillColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Description / Notes", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: kTextColor),
                maxLines: 2,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "How did it feel?",
                  hintStyle: TextStyle(color: kTextColor.withValues(alpha: 0.3)),
                  filled: true,
                  fillColor: kInputFillColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Activity Type", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: kInputFillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    dropdownColor: kInputFillColor,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: kSecondaryColor),
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    items: ['Strength', 'Cardio', 'HIIT', 'Yoga'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Date", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: kInputFillColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM d, yyyy').format(_selectedDate),
                        style: const TextStyle(color: kTextColor, fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, color: kSecondaryColor, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Duration (min)", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _durationController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: kTextColor),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(color: kTextColor.withValues(alpha: 0.3)),
                            filled: true,
                            fillColor: kInputFillColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Volume (kg/km)", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _volumeController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: kTextColor),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(color: kTextColor.withValues(alpha: 0.3)),
                            filled: true,
                            fillColor: kInputFillColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isEditing ? "UPDATE ACTIVITY" : "SAVE ACTIVITY",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}