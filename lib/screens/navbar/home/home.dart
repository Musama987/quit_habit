import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quit_habit/screens/navbar/home/widgets/breathing/breathing.dart';
import 'package:quit_habit/screens/navbar/home/widgets/calender/calender.dart';
import 'package:quit_habit/screens/navbar/home/widgets/meditation/meditation.dart';
import 'package:quit_habit/screens/navbar/home/widgets/physical_workout/movement.dart';
import 'package:quit_habit/screens/navbar/home/widgets/relapse/relapse.dart';
import 'package:quit_habit/screens/navbar/home/widgets/tools/tools.dart';
import 'package:quit_habit/services/habit_service.dart';
import 'package:quit_habit/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HabitService _habitService = HabitService();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to track your progress")),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _habitService.getUserHabitStream(_user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        // Loading state or initial state
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final Timestamp? startDateTs = data?['startDate'] as Timestamp?;
        final List<dynamic> relapseDatesRaw =
            data?['relapseDates'] as List<dynamic>? ?? [];

        final DateTime? startDate = startDateTs?.toDate();
        final List<DateTime> relapseDates = relapseDatesRaw
            .map((e) => (e as Timestamp).toDate())
            .toList();

        // Calculate Streak
        int streak = 0;
        bool isActive = false;

        if (startDate != null) {
          isActive = true;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final start = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          );

          if (relapseDates.isNotEmpty) {
            // Sort to find latest relapse
            relapseDates.sort((a, b) => a.compareTo(b));
            final lastRelapse = relapseDates.last;
            final lastRelapseDay = DateTime(
              lastRelapse.year,
              lastRelapse.month,
              lastRelapse.day,
            );

            if (lastRelapseDay.isAtSameMomentAs(today)) {
              streak = 0;
            } else {
              streak = today.difference(lastRelapseDay).inDays;
            }
          } else {
            // No relapses
            streak = today.difference(start).inDays + 1;
          }
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundLight,
            elevation: 0,
            titleSpacing: 20,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                _buildTopStat(Icons.shield_outlined, "0%", Colors.cyan),
                const SizedBox(width: 8),
                _buildTopStat(Icons.diamond_outlined, "1", AppColors.primary),
                const SizedBox(width: 8),
                _buildTopStat(
                  Icons.monetization_on_outlined,
                  "0",
                  Colors.amber,
                ),
                const Spacer(),
                _buildProButton(),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Main Tracker Card
                _buildTrackerCard(textTheme, streak, isActive),

                const SizedBox(height: 24),

                // 2. Distractions Section
                _buildSectionHeader(
                  "Need a Distraction?",
                  showViewAll: true,
                  onViewAllPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const ToolsScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDistractionCard(
                        Icons.air,
                        "Breathing",
                        const Color(0xFFFFE2E2),
                        const Color(0xFFEF4444),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const BreathingScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.sizeUp,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDistractionCard(
                        Icons.show_chart,
                        "Exercise",
                        const Color(0xFFE0F2FE),
                        const Color(0xFF3B82F6),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const MovementScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.sizeUp,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDistractionCard(
                        Icons.self_improvement,
                        "Meditate",
                        const Color(0xFFDCFCE7),
                        const Color(0xFF10B981),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const MeditationScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.sizeUp,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // 3. Weekly Progress
                _buildSectionHeader(
                  "Weekly Progress",
                  showViewAll: true,
                  actionText: "Calendar",
                  onViewAllPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const CalendarScreen(
                        mode: CalendarMode.reportRelapse,
                      ),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildWeeklyProgress(startDate, relapseDates),

                // 4. Active Challenge
                _buildSectionHeader("Active Challenge"),
                const SizedBox(height: 12),
                _buildChallengeCard(textTheme),

                const SizedBox(height: 24),

                // 5. Today's Plan
                _buildSectionHeader("Today's Plan", showViewAll: true),
                const SizedBox(height: 12),
                _buildPlanCard(textTheme),

                const SizedBox(height: 24),

                // 6. Premium Banner
                _buildPremiumCard(textTheme),

                const SizedBox(height: 40),
              ],
            ),
          ),
          floatingActionButton: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              boxShadow: [AppColors.softShadow],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.primary,
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  // --- Widgets Methods ---

  Widget _buildTrackerCard(TextTheme textTheme, int streak, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ready to start\nBegin",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
              const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: "Day ",
              style: textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 28,
              ),
              children: [
                TextSpan(
                  text: "$streak",
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Removed Progress Bar as requested
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isActive) {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const RelapseScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    } else {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const CalendarScreen(
                          mode: CalendarMode.startRoutine,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive
                        ? AppColors.error
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    isActive ? "Report Relapse" : "Start Your Routine",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(
    DateTime? startDate,
    List<DateTime> relapseDates,
  ) {
    // Calculate dates for the current week (Mon-Sun)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Find Monday of this week
    // weekday: Mon=1, Sun=7
    final monday = today.subtract(Duration(days: today.weekday - 1));

    List<Widget> dayBubbles = [];
    final weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dayName = weekDays[i];

      // Determine status
      Color color = Colors.grey; // Default/Future
      bool isChecked = false;
      bool isRelapse = false;

      if (date.isAfter(today)) {
        // Future days
        color = Colors.grey;
        isChecked = false;
      } else {
        // Past or Today
        if (startDate == null ||
            date.isBefore(
              DateTime(startDate.year, startDate.month, startDate.day),
            )) {
          // Before start date
          color = Colors.grey;
          isChecked = false;
        } else {
          // Active period
          // Check if relapse
          bool isRelapseDay = relapseDates.any(
            (d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day,
          );

          if (isRelapseDay) {
            color = AppColors.error; // Red for relapse
            isRelapse = true;
            isChecked = true; // Show icon
          } else {
            color = Colors.blue; // Or primary color for success
            isChecked = true;
          }
        }
      }

      dayBubbles.add(
        _buildDayBubble(dayName, isChecked, color, isRelapse: isRelapse),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.softShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dayBubbles,
      ),
    );
  }

  Widget _buildDayBubble(
    String day,
    bool isChecked,
    Color color, {
    bool isRelapse = false,
  }) {
    bool isEmpty = color == Colors.grey;

    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isEmpty ? Colors.grey[100] : color,
            shape: BoxShape.circle,
          ),
          child: isEmpty
              ? null
              : Icon(
                  isRelapse ? Icons.close : Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
        ),
      ],
    );
  }

  Widget _buildDistractionCard(
    IconData icon,
    String label,
    Color bg,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.01, 0.01],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppColors.softShadow],
      ),
      padding: const EdgeInsets.all(6),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              "7-Day Warrior",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Stay smoke-free for 7 consecutive days",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  "Progress",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  "71%",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.71,
                minHeight: 8,
                backgroundColor: Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFDCFCE7),
            child: Icon(Icons.spa, color: AppColors.success, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            "Day 3 • Active",
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckItem("Make commitment to quit smoking day by day.", true),
          const SizedBox(height: 12),
          _buildCheckItem(
            "Establish immediate health benefits with quit habit",
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, bool isChecked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.circle,
          color: isChecked ? AppColors.success : Colors.grey[300],
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium,
            color: AppColors.premium,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            "Unlock Premium",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Get unlimited challenges, advanced analytics,\nand exclusive tools!",
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.premiumGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Upgrade to Pro",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    bool showViewAll = false,
    String actionText = "View All",
    VoidCallback? onViewAllPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (showViewAll)
          TextButton(
            onPressed: onViewAllPressed ?? () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_forward,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTopStat(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.workspace_premium, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            "Pro",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
