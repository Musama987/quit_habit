import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class QuestionnaireThreeScreen extends StatefulWidget {
  const QuestionnaireThreeScreen({super.key});

  @override
  State<QuestionnaireThreeScreen> createState() => _QuestionnaireThreeScreenState();
}

class _QuestionnaireThreeScreenState extends State<QuestionnaireThreeScreen> {
  final TextEditingController _moneyController = TextEditingController();

  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // resizeToAvoidBottomInset: true is default, which allows the button to move up with keyboard
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
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
                            'Question 3 of 5',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '60%',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Progress Bar (60%)
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.6,
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
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          shape: BoxShape.circle,
                          boxShadow: [AppColors.softShadow],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.payments_outlined,
                            size: 48,
                            color: AppColors.success,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // --- 3. Question Title ---
                      Text(
                        'How much money do you\nspend per day?',
                        textAlign: TextAlign.center,
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          color: AppColors.textPrimary,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // --- 4. Money Input Field ---
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            )
                          ],
                        ),
                        child: TextFormField(
                          controller: _moneyController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: '\$0.00',
                            hintStyle: textTheme.headlineSmall?.copyWith(
                              color: AppColors.textTertiary.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      // This SizedBox ensures a gap exists even when the keyboard is up
                      const SizedBox(height: 25),

                      // The Spacer pushes the button to the bottom when keyboard is closed,
                      // but shrinks to 0 when keyboard is open (leaving only the SizedBox above).
                      const Spacer(),

                      // --- 5. Next Button ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Validate input and Navigate to Question 4
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Next'),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}