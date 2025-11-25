import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class QuestionnaireOneScreen extends StatefulWidget {
  const QuestionnaireOneScreen({super.key});

  @override
  State<QuestionnaireOneScreen> createState() => _QuestionnaireOneScreenState();
}

class _QuestionnaireOneScreenState extends State<QuestionnaireOneScreen> {
  // State to track the selected option
  int? _selectedIndex;

  final List<String> _options = [
    'Less than 1 year',
    '1-5 years',
    '5-10 years',
    'More than 10 years',
  ];

  void _handleOptionSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Optional: Add navigation logic here after a short delay
    // Future.delayed(const Duration(milliseconds: 300), () { ... });
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
                    'Question 1 of 5',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '20%',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Custom Gradient Progress Bar (Reused logic from OnboardingOne)
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.2, // 20% progress
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- 2. Icon ---
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  boxShadow: [AppColors.softShadow],
                ),
                child: const Center(
                  child: Icon(
                    Icons.smoking_rooms, // Using material icon as placeholder for the specific asset
                    size: 40,
                    color: AppColors.textSecondary, 
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- 3. Question Title ---
              Text(
                'How long have you been smoking?',
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // --- 4. Options List ---
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                padding: const EdgeInsets.only(bottom: 50.0),
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
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [AppColors.softShadow], // Default soft shadow
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: textTheme.bodyLarge?.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
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