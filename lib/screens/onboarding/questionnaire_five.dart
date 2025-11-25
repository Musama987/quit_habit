import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';
import 'package:quit_habit/screens/navbar/navbar.dart';

class QuestionnaireFiveScreen extends StatefulWidget {
  const QuestionnaireFiveScreen({super.key});

  @override
  State<QuestionnaireFiveScreen> createState() =>
      _QuestionnaireFiveScreenState();
}

class _QuestionnaireFiveScreenState extends State<QuestionnaireFiveScreen> {
  // State to track the selected option
  int? _selectedIndex;

  final List<String> _options = [
    'In the morning',
    'During work breaks',
    'Social situations',
    'When stressed',
  ];

  void _handleOptionSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logic to finish onboarding
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // Show a "Processing" indicator or navigate to Home
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Onboarding Complete! Creating your plan..."),
      //     backgroundColor: AppColors.success,
      //     duration: Duration(seconds: 2),
      //   ),
      // );

      // Navigate to the main app (clear onboarding stack)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavBar()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- 1. Progress Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question 5 of 5',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '100%',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Bar (100%)
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1.0, // 100% Width
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- 2. Hero Icon (Clock) ---
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  boxShadow: [AppColors.softShadow],
                ),
                child: const Center(
                  child: Icon(
                    Icons.access_time,
                    size: 48,
                    color: AppColors.textPrimary, 
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- 3. Question Title ---
              Text(
                'When do you smoke the\nmost?',
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  color: AppColors.textPrimary,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // --- 4. Options List ---
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _options.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIndex == index;
                    return _buildOptionCard(
                      text: _options[index],
                      isSelected: isSelected,
                      onTap: () => _handleOptionSelected(index),
                      textTheme: textTheme,
                    );
                  },
                ),
              ),

              // --- 5. Footer Hint ---
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Select an option to continue',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required TextTheme textTheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          // Add a border when selected to make it distinct
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [AppColors.softShadow],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: textTheme.bodyLarge?.copyWith(
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            // Show checkmark if selected
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}