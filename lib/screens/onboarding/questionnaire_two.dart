import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';
import 'package:quit_habit/screens/onboarding/questionnaire_three.dart'; 

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

  void _handleOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });

    // Add a small delay so the user sees the selection effect before moving on
    Future.delayed(const Duration(milliseconds: 10), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuestionnaireThreeScreen()),
        );
      }
    });
  }

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
                    const SizedBox(height: 8), 
                    
                    // Custom Gradient Progress Bar
                    Stack(
                      children: [
                        Container(
                          height: 6, 
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              height: 6, 
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

                    const SizedBox(height: 24), 

                    // --- 2. Icon Illustration ---
                    Container(
                      width: 80, 
                      height: 80, 
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 20, 
                            spreadRadius: 2, 
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.smoking_rooms_outlined,
                          size: 40, 
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20), 

                    // --- 3. Question Text ---
                    Text(
                      'How many cigarettes do\nyou smoke per day?',
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: 22, 
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        height: 1.2, 
                      ),
                    ),

                    const SizedBox(height: 24), 

                    // --- 4. Options List ---
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12), 
                      itemBuilder: (context, index) {
                        final isSelected = _selectedOptionIndex == index;
                        return _buildOptionCard(
                          text: _options[index],
                          isSelected: isSelected,
                          onTap: () => _handleOptionSelected(index),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16), 
                  ],
                ),
              ),
            ),

            // --- 5. Bottom Footer (Replaced Button) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20), 
              child: Text(
                'Step 2 of 5 • Tracking details',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 12,
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), 
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14), 
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
                      fontSize: 15, 
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