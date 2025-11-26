import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class MovementScreen extends StatefulWidget {
  const MovementScreen({super.key});

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  // State Variables
  bool _isActive = false;
  int _rounds = 0;
  
  // Total Duration Timer
  int _totalSeconds = 0;
  Timer? _durationTimer;

  // Exercise Countdown Timer (30 seconds per set)
  static const int _exerciseDuration = 30;
  int _currentCountdown = _exerciseDuration;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _durationTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // --- Logic ---

  void _toggleWorkout() {
    setState(() {
      _isActive = !_isActive;
    });

    if (_isActive) {
      _startTimers();
    } else {
      _stopTimers();
    }
  }

  void _startTimers() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalSeconds++;
      });
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentCountdown > 0) {
        setState(() {
          _currentCountdown--;
        });
      } else {
        setState(() {
          _rounds++;
          _currentCountdown = _exerciseDuration; 
        });
      }
    });
  }

  void _stopTimers() {
    _durationTimer?.cancel();
    _countdownTimer?.cancel();
  }

  String _formatDuration(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          // Reduced vertical padding for compactness
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- 1. Header (Title + Close) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Movement",
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 26, // Slightly smaller
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      Text(
                        "Quick Circuit",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12), // Reduced spacing

              // --- 2. Progress Bars ---
              Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColors.primary : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16), // Reduced spacing

              // --- 3. Stats Row (Compact) ---
              Row(
                children: [
                  // Rounds
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10), // Compact padding
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF), 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "$_rounds",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const Text(
                            "Rounds",
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Duration
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10), // Compact padding
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5), 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _formatDuration(_totalSeconds),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const Text(
                            "Duration",
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20), // Reduced spacing

              // --- 4. Exercise Counter Text ---
              Text(
                "Exercise 1 of 5",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 10), // Reduced spacing

              // --- 5. Jumping Jack Icon (The "Physical Man") ---
              // Using Icons.accessibility_new as it perfectly mimics the Jumping Jack pose
              Container(
                height: 120, // Fixed compact height
                width: 120,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.accessibility_new_rounded, // Man with arms and legs open
                  size: 100, 
                  color: Colors.amber, // Matches the yellow/orange in your design
                ),
              ),

              const SizedBox(height: 5), // Reduced spacing

              // --- 6. Title & Subtitle ---
              Text(
                "Jumping Jacks",
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Jump with legs apart, arms overhead",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20), // Reduced spacing

              // --- 7. Circular Timer ---
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background Circle
                  SizedBox(
                    width: 140, // Smaller circle
                    height: 140,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                    ),
                  ),
                  // Progress Circle
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: _currentCountdown / _exerciseDuration,
                      strokeWidth: 8,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primarymedium),
                      backgroundColor: Colors.transparent,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  // Text
                  Text(
                    "$_currentCountdown",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15), // Reduced spacing

              // --- 8. Start Button ---
              SizedBox(
                width: double.infinity,
                height: 50, // Slightly shorter button
                child: ElevatedButton(
                  onPressed: _toggleWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isActive ? Icons.pause : Icons.play_arrow_rounded, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        _isActive ? "Pause Workout" : "Start Workout",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10), // Reduced spacing

              // --- 9. Info Card ---
              Container(
                padding: const EdgeInsets.all(12), // Compact padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(Icons.bolt, color: Colors.amber, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Physical activity releases endorphins, reduces stress, and provides an immediate distraction from cravings.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}