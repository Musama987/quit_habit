import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  // State
  int _selectedDuration = 5; // Default 5 minutes
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Logic ---

  void _resetTimer() {
    setState(() {
      _remainingSeconds = _selectedDuration * 60;
    });
  }

  void _selectDuration(int minutes) {
    if (_isRunning) return; // Prevent changing while running
    setState(() {
      _selectedDuration = minutes;
      _resetTimer();
    });
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _stopTimer(); // Timer finished
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _selectedDuration * 60; // Reset on stop
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Calculate progress: 1.0 is full, 0.0 is empty
    double progress = _remainingSeconds / (_selectedDuration * 60);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. Compact Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Meditation",
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 24, // Slightly smaller font
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Guided mindfulness",
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
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70), // Reduced vertical spacing

            // --- 2. Smaller Circular Timer ---
            Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle (Faint Grey)
                SizedBox(
                  width: 200, // Reduced from 260
                  height: 200, // Reduced from 260
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12, // Reduced thickness
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFF3F4F6)),
                  ),
                ),
                // Progress Circle (Blue)
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    backgroundColor: Colors.transparent,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Center Text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 48, // Reduced from 60
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      "remaining",
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- 3. Duration Selector ---
            Text(
              "Select duration",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDurationOption(3),
                  const SizedBox(width: 12),
                  _buildDurationOption(5),
                  const SizedBox(width: 12),
                  _buildDurationOption(10),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 4. Smaller Start Button ---
            SizedBox(
              width: 150, // Reduced width
              height: 48, // Reduced height
              child: ElevatedButton(
                onPressed: _toggleTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning ? AppColors.error : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero, // Remove padding to fit fixed size
                  elevation: 2,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isRunning ? Icons.pause : Icons.play_arrow_rounded, size: 24),
                    const SizedBox(width: 6),
                    Text(
                      _isRunning ? "Pause" : "Start",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15, // Reduced font size
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30), // Pushes the guide to the bottom

            // --- 5. Compact Guide Card ---
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Meditation guide:",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildGuideItem("Sit comfortably with a straight back"),
                  const SizedBox(height: 6),
                  _buildGuideItem("Close your eyes or lower your gaze"),
                  const SizedBox(height: 6),
                  _buildGuideItem("When mind wanders, gently return focus"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Duration Buttons
  Widget _buildDurationOption(int minutes) {
    bool isSelected = _selectedDuration == minutes;
    
    return GestureDetector(
      onTap: () => _selectDuration(minutes),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Smaller padding
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected 
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))] 
            : [],
        ),
        child: Text(
          "$minutes min",
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Helper for Bullet Points in Guide
  Widget _buildGuideItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}