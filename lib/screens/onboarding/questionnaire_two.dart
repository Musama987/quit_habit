import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class QuestionnaireTwoScreen extends StatefulWidget {
  const QuestionnaireTwoScreen({super.key});

  @override
  State<QuestionnaireTwoScreen> createState() => _QuestionnaireTwoScreenState();
}

class _QuestionnaireTwoScreenState extends State<QuestionnaireTwoScreen> {
  int? _selectedOptionIndex;

  final List<String> _options = [
    '1–5 cigarettes',
    '6–10 cigarettes',
    '11–20 cigarettes',
    'More than 20 cigarettes',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        // Reduced toolbar height slightly if needed, but standard is usually fine.
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Reduced top spacing
                    const SizedBox(height: 0), 

                    // --- 1. Progress Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question 2 of 5',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '40%',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Reduced from 12
                    
                    // Custom Gradient Progress Bar
                    Stack(
                      children: [
                        Container(
                          height: 6, // Reduced thickness from 8
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              height: 6, // Reduced thickness from 8
                              width: constraints.maxWidth * 0.4,
                              decoration: BoxDecoration(
                                gradient: AppColors.purpleGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24), // Reduced from 40

                    // --- 2. Icon Illustration (Scaled Down) ---
                    Container(
                      width: 80, // Reduced from 100
                      height: 80, // Reduced from 100
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 20, // Reduced blur
                            spreadRadius: 2, // Reduced spread
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.smoking_rooms_outlined,
                          size: 40, // Reduced from 48
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20), // Reduced from 32

                    // --- 3. Question Text ---
                    Text(
                      'How many cigarettes do\nyou smoke per day?',
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: 22, // Slightly smaller font
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        height: 1.2, // Tighter line height
                      ),
                    ),

                    const SizedBox(height: 24), // Reduced from 32

                    // --- 4. Options List ---
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12), // Reduced from 16
                      itemBuilder: (context, index) {
                        final isSelected = _selectedOptionIndex == index;
                        return _buildOptionCard(
                          text: _options[index],
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedOptionIndex = index;
                            });
                          },
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16), // Extra bottom padding for scroll
                  ],
                ),
              ),
            ),

            // --- 5. Bottom Section ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20), // Reduced bottom padding from 32
              child: _selectedOptionIndex == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Select an option to continue',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to Question 3
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14), // Compact button height
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Compact padding inside the card
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), 
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14), // Slightly tighter radius
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 15, // Slightly adjusted font size
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