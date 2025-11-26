import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Top Stats Card ---
              _buildStatsCard(context, textTheme),

              const SizedBox(height: 24),

              // --- 2. Tools Grid ---
              _buildToolsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purpleLight), // Light purple border
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cravings Defeated Today",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "12",
                style: textTheme.displayMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Right Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Most Used",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Breathing",
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.purple, // Using purple accent
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6), // Align slightly with the baseline of "12"
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolsGrid(BuildContext context) {
    // Defining tool data locally to keep it clean
    final List<Map<String, dynamic>> tools = [
      {
        'title': 'Breathing',
        'subtitle': 'Calm cravings',
        'icon': Icons.air,
        'color': Colors.cyan,
        'bg': const Color(0xFFE0F7FA), // Light Cyan
      },
      {
        'title': 'Physical Workout',
        'subtitle': 'Quick workouts',
        'icon': Icons.fitness_center,
        'color': Colors.deepOrange,
        'bg': const Color(0xFFFFF7ED), // Light Orange
      },
      {
        'title': 'Meditation',
        'subtitle': 'Find peace',
        'icon': Icons.psychology, // Brain icon
        'color': AppColors.purple,
        'bg': AppColors.purpleLight,
      },
      {
        'title': 'Word Puzzle',
        'subtitle': 'Distract mind',
        'icon': Icons.calculate_outlined, // Calculator/Grid look
        'color': AppColors.success,
        'bg': AppColors.successLight,
      },
      {
        'title': 'Inspiration',
        'subtitle': 'Daily quotes',
        'icon': Icons.auto_awesome, // Sparkles
        'color': const Color(0xFFD97706), // Darker Gold
        'bg': const Color(0xFFFEFCE8), // Light Yellow
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4, // Rectangular aspect ratio
      ),
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _buildToolCard(
          context,
          title: tool['title'],
          subtitle: tool['subtitle'],
          icon: tool['icon'],
          iconColor: tool['color'],
          bgColor: tool['bg'],
        );
      },
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle tool tap
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}