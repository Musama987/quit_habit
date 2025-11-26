import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quit_habit/utils/app_colors.dart';

enum BreathingPhase { idle, inhale, hold, exhale }

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _controller;
  
  // Logic State
  BreathingPhase _phase = BreathingPhase.idle;
  Timer? _timer;
  int _displayNumber = 4;
  String _instruction = "Get Ready";
  int _cyclesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // --- Breathing Logic ---

  void _toggleBreathing() {
    if (_phase == BreathingPhase.idle) {
      _startCycle();
    } else {
      _stopBreathing();
    }
  }

  void _stopBreathing() {
    _timer?.cancel();
    _controller.stop();
    _controller.reset();
    setState(() {
      _phase = BreathingPhase.idle;
      _displayNumber = 4;
      _instruction = "Ready to start?";
      _cyclesCompleted = 0;
    });
  }

  void _startCycle() {
    // 1. Inhale (4 Seconds)
    _runPhase(
      phase: BreathingPhase.inhale,
      duration: 4,
      label: "Breathe In",
      onComplete: () {
        // 2. Hold (4 Seconds)
        _runPhase(
          phase: BreathingPhase.hold,
          duration: 4,
          label: "Hold",
          onComplete: () {
            // 3. Exhale (6 Seconds)
            _runPhase(
              phase: BreathingPhase.exhale,
              duration: 6,
              label: "Breathe Out",
              onComplete: () {
                _cyclesCompleted++;
                _startCycle(); // Loop
              },
            );
          },
        );
      },
    );
  }

  void _runPhase({
    required BreathingPhase phase,
    required int duration,
    required String label,
    required VoidCallback onComplete,
  }) {
    setState(() {
      _phase = phase;
      _instruction = label;
      _displayNumber = duration;
    });

    _controller.duration = Duration(seconds: duration);
    _controller.reset();
    _controller.forward();

    int localCount = duration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (localCount <= 1) {
        timer.cancel();
        onComplete();
      } else {
        setState(() {
          localCount--;
          _displayNumber = localCount;
        });
      }
    });
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. Custom Compact Header (Title Left, X Right) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Breathing Exercise",
                          style: textTheme.displayMedium?.copyWith(
                            fontSize: 22, // Compact font size
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "4-4-6 breathing pattern",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8), // Slightly larger touch area
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

            // --- 2. Scrollable Main Content (Prevents Overflow) ---
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space nicely
                          children: [
                            const SizedBox(height: 20),
                            
                            // Animated Circle
                            _buildAnimatedCircle(textTheme),

                            const SizedBox(height: 30),

                            // Info Box
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Follow the breathing pattern to calm your mind and reduce cravings",
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Start/Stop Button
                            SizedBox(
                              width: 160,
                              child: ElevatedButton(
                                onPressed: _toggleBreathing,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _phase == BreathingPhase.idle 
                                      ? AppColors.primary 
                                      : AppColors.error,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _phase == BreathingPhase.idle ? Icons.play_arrow_rounded : Icons.stop_rounded,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _phase == BreathingPhase.idle ? "Start" : "Stop",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Tips Section (Bottom Card)
                            Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB), // Very light grey for card
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tips for best results:",
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTipItem("Find a quiet, comfortable place"),
                                  const SizedBox(height: 8),
                                  _buildTipItem("Close your eyes or soften your gaze"),
                                  const SizedBox(height: 8),
                                  _buildTipItem("Complete at least 5 cycles for maximum benefit"),
                                ],
                              ),
                            ),
                            
                            // Bottom Padding to prevent sticking to edge on small screens
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(TextTheme textTheme) {
    return SizedBox(
      width: 240, // Reduced slightly to fit smaller screens better
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Faint Circle
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarymedium.withOpacity(0.5),
            ),
          ),
          
          // Animated Progress Circle
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  value: _phase == BreathingPhase.idle ? 0 : _controller.value,
                  strokeWidth: 10,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  backgroundColor: Colors.transparent,
                  strokeCap: StrokeCap.round,
                ),
              );
            },
          ),

          // Center Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  _phase == BreathingPhase.idle ? "4" : "$_displayNumber",
                  key: ValueKey<int>(_displayNumber),
                  style: GoogleFonts.inter(
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _instruction,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
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
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}