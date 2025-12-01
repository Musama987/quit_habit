import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:quit_habit/utils/app_colors.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Simulate current progress (Day 3 is active)
  final int _currentDay = 3;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          // Reduced vertical padding for compactness
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Top Stats Row ---
              Row(
                children: [
                  _buildTopStat(Icons.shield_outlined, "0%", Colors.cyan),
                  const SizedBox(width: 8),
                  _buildTopStat(Icons.diamond_outlined, "1", AppColors.primary),
                  const SizedBox(width: 8),
                  _buildTopStat(Icons.monetization_on_outlined, "0", Colors.amber),
                  const Spacer(),
                  _buildProButton(textTheme),
                ],
              ),

              const SizedBox(height: 16), 

              // --- 2. Current Progress Card ---
              Container(
                padding: const EdgeInsets.all(16), 
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [AppColors.softShadow],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10), 
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6D00),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Day $_currentDay",
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    fontSize: 20, 
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "STREAK",
                                    style: textTheme.labelSmall?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "/ 90 Days",
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 12), 
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD1FAE5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.success, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Freedom Day: Feb 5, 2026",
                              style: TextStyle(
                                color: const Color(0xFF065F46),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- 3. The 90 Day Timeline ---
              ..._buildTimelineList(textTheme),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTimelineList(TextTheme textTheme) {
    List<Widget> widgets = [];

    // Phase 1: Withdrawal (Days 1-14)
    widgets.add(_buildPhaseCard(
      title: "Withdrawal Phase",
      subtitle: "The hardest battle begins • Days 1-14",
      icon: Icons.error_outline,
      color: AppColors.error,
      bgColor: const Color(0xFFFEF2F2),
      borderColor: const Color(0xFFFECACA),
    ));
    widgets.add(const SizedBox(height: 8)); // Compact spacing

    for (int day = 1; day <= 90; day++) {
      
      // Inject Phases based on intervals
      if (day == 15) {
        widgets.add(const SizedBox(height: 4));
        widgets.add(_buildPhaseCard(
          title: "Recovery Phase",
          subtitle: "Your body starts healing • Days 15-28",
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          bgColor: const Color(0xFFECFDF5),
          borderColor: const Color(0xFFA7F3D0),
        ));
        widgets.add(const SizedBox(height: 8));
      } else if (day == 29) {
        widgets.add(const SizedBox(height: 4));
        widgets.add(_buildPhaseCard(
          title: "Adjustment Phase",
          subtitle: "Finding your new normal • Days 29-42",
          icon: Icons.bolt,
          color: AppColors.primary,
          bgColor: AppColors.primaryLight,
          borderColor: const Color(0xFFBFDBFE),
        ));
        widgets.add(const SizedBox(height: 8));
      } else if (day == 43) {
        widgets.add(const SizedBox(height: 4));
        widgets.add(_buildPhaseCard(
          title: "Transformation Phase",
          subtitle: "New habits are forming • Days 43-56",
          icon: Icons.auto_awesome,
          color: Colors.purple,
          bgColor: const Color(0xFFFAF5FF),
          borderColor: const Color(0xFFE9D5FF),
        ));
        widgets.add(const SizedBox(height: 8));
      } else if (day == 57) {
        widgets.add(const SizedBox(height: 4));
        widgets.add(_buildPhaseCard(
          title: "Strengthening Phase",
          subtitle: "Solidifying your resolve • Days 57-70",
          icon: Icons.fitness_center,
          color: Colors.orange,
          bgColor: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFED7AA),
        ));
        widgets.add(const SizedBox(height: 8));
      } else if (day == 71) {
        widgets.add(const SizedBox(height: 4));
        widgets.add(_buildPhaseCard(
          title: "Mastery Phase",
          subtitle: "Total freedom achieved • Days 71-84",
          icon: Icons.emoji_events,
          color: const Color(0xFFCA8A04),
          bgColor: const Color(0xFFFEFCE8),
          borderColor: const Color(0xFFFEF08A),
        ));
        widgets.add(const SizedBox(height: 8));
      } else if (day == 85) { 
        // Freedom Phase after Day 84
        widgets.add(const SizedBox(height: 4));
        widgets.add(_buildPhaseCard(
          title: "Freedom Phase",
          subtitle: "Living smoke-free • Days 85-90",
          icon: Icons.flight_takeoff,
          color: Colors.teal,
          bgColor: const Color(0xFFF0FDFA), // Light teal
          borderColor: const Color(0xFF99F6E4),
        ));
        widgets.add(const SizedBox(height: 8));
      }

      widgets.add(_buildDayTile(day, textTheme, day == 90));
    }

    return widgets;
  }

  Widget _buildPhaseCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      // Very compact padding
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6), 
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTile(int day, TextTheme textTheme, bool isLast) {
    bool isCompleted = day < _currentDay;
    bool isCurrent = day == _currentDay;
    bool isLocked = day > _currentDay;

    String title = "Day $day";
    String? subtitle;
    String? badgeText;

    // Specific text from Image
    if (day == 1) {
      title = "Day 1 • The Decision";
      badgeText = "MILESTONE";
      subtitle = "Make your commitment to quit smoking\nSet your quit date and prepare mentally"; 
    } else if (day == 2) {
      title = "Day 2 • Building Strength";
      subtitle = "Your body begins healing process\nCarbon monoxide levels start to normalize";
    } else if (day == 3) {
      title = "Day 3 • First Milestone";
      subtitle = "Nicotine withdrawal peaks today\nStay strong, cravings will reduce soon";
    } else if (isLocked) {
      subtitle = "Locked";
    }

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.0,
      isFirst: day == 1,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20, 
        padding: const EdgeInsets.only(bottom: 2),
        indicator: _buildIndicator(isCompleted, isCurrent, isLocked),
        drawGap: true,
      ),
      beforeLineStyle: LineStyle(
        color: AppColors.border,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: AppColors.border,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 10.0, bottom: 8.0), // Compact margin
        child: Container(
          width: double.infinity,
          // Compact padding inside the day card
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrent ? AppColors.error.withOpacity(0.3) : AppColors.border,
              width: isCurrent ? 1.5 : 1,
            ),
            boxShadow: [
              if (!isLocked) AppColors.softShadow,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isLocked ? AppColors.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                  if (badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Color(0xFFD97706),
                          fontWeight: FontWeight.bold,
                          fontSize: 9, 
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (isLocked)
                    const Icon(Icons.lock_outline, size: 14, color: AppColors.textTertiary),
                ],
              ),
              
              if (subtitle != null) ...[
                const SizedBox(height: 4), 
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isLocked ? AppColors.textTertiary : AppColors.textSecondary,
                    fontSize: 11,
                    // Italics for active days (1-3) based on image style
                    fontStyle: isLocked ? FontStyle.normal : FontStyle.italic, 
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isCompleted, bool isCurrent, bool isLocked) {
    if (isCompleted) {
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 12),
      );
    } else if (isCurrent) {
      // Current Day Indicator (Orange Ring)
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFF6D00), width: 3),
        ),
        child: Center(
          child: Container(
            width: 6, 
            height: 6, 
            decoration: const BoxDecoration(
              color: Color(0xFFFF6D00), 
              shape: BoxShape.circle
            ),
          ),
        ),
      );
    } else {
      // LOCKED STATE - "Inside dot and then outside the circle"
      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          shape: BoxShape.circle,
          // Outline circle
          border: Border.all(
            color: AppColors.textTertiary.withOpacity(0.5), 
            width: 1.5, 
          ),
        ),
        // Inside dot
        child: Center(
          child: Container(
            width: 6, 
            height: 6, 
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.5), 
              shape: BoxShape.circle
            ),
          ),
        ),
      );
    }
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

  Widget _buildProButton(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            "Pro",
            style: textTheme.labelLarge?.copyWith(
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