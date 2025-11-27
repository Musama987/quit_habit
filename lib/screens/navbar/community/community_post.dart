import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class CommunityPostScreen extends StatefulWidget {
  const CommunityPostScreen({super.key});

  @override
  State<CommunityPostScreen> createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  bool _showStreak = false;
  final TextEditingController _textController = TextEditingController();
  int _charCount = 0;

  // Mock data for the streak week
  final List<Map<String, dynamic>> _weekData = [
    {'day': 'Thu', 'status': 'clean'},
    {'day': 'Fri', 'status': 'relapse'},
    {'day': 'Sat', 'status': 'clean'},
    {'day': 'Sun', 'status': 'clean'},
    {'day': 'Mon', 'status': 'clean'}, // Current day (orange check)
    {'day': 'Tue', 'status': 'future'},
    {'day': 'Wed', 'status': 'future'},
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _charCount = _textController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Get screen height to make adjustments responsive
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenHeight < 700;

    // Responsive sizing variables
    final double cardPaddingV = isSmallScreen ? 10.0 : 12.0;
    final double cardPaddingH = isSmallScreen ? 12.0 : 16.0;
    final double sectionSpacing = isSmallScreen ? 10.0 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Reduced side padding slightly
          child: Column(
            children: [
              SizedBox(height: isSmallScreen ? 4 : 8),
              // --- 1. Top Stats Row ---
              Row(
                children: [
                  _buildTopStat(Icons.shield_outlined, "0%", Colors.cyan),
                  const SizedBox(width: 8),
                  _buildTopStat(Icons.diamond_outlined, "1", AppColors.primary),
                  const SizedBox(width: 8),
                  _buildTopStat(
                      Icons.monetization_on_outlined, "0", Colors.amber),
                  const Spacer(),
                  _buildProButton(textTheme),
                ],
              ),

              SizedBox(height: isSmallScreen ? 8 : 12),

              // --- 2. Custom Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Text(
                    "New Post",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(
                    height: 32, // More compact button
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement Post Logic
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text("Post"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: sectionSpacing),

              // --- 3. Streak Toggle Card (Updated) ---
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                    horizontal: cardPaddingH, vertical: cardPaddingV),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Toggle Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6), // Smaller icon padding
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF7ED), // Light orange bg
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.whatshot,
                              color: Colors.orange, size: 20), // Smaller icon
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Show Streak",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, // Smaller font
                                ),
                              ),
                              Text(
                                "Display your current progress",
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11, // Smaller font
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Compact Switch
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _showStreak,
                            onChanged: (val) {
                              setState(() {
                                _showStreak = val;
                              });
                            },
                            activeColor: AppColors.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),

                    // Expanded Content (The Calendar View)
                    if (_showStreak) ...[
                      const SizedBox(height: 12),
                      // Inner Blue Card
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFFEFF6FF), // Very light blue background
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.blue.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row inside streak card
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Current Streak",
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.whatshot,
                                          color: Colors.orange, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        "4 days",
                                        style: TextStyle(
                                          color: Colors.orange[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Days Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _weekData
                                  .map((data) => _buildDayItem(data))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: sectionSpacing),

              // --- 4. Main Input Card ---
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: cardPaddingH, vertical: cardPaddingV),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 16, // Smaller avatar
                          backgroundColor: AppColors.primary,
                          child: Text(
                            "YU",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Name",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Posting publicly",
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Text Input
                    TextField(
                      controller: _textController,
                      // More compact maxLines
                      maxLines: isSmallScreen ? 4 : 6,
                      maxLength: 500,
                      style: const TextStyle(fontSize: 13), // Slightly smaller font
                      decoration: InputDecoration(
                        hintText:
                            "Share your thoughts, progress, or ask for support...",
                        hintStyle: TextStyle(
                            color: AppColors.textTertiary, fontSize: 13),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: "",
                        isDense: true, // Reduces internal padding
                      ),
                    ),

                    const Divider(height: 16, color: AppColors.border),

                    // Character Counter
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$_charCount/500",
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sectionSpacing),

              // --- 5. Guidelines Card ---
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: cardPaddingH, vertical: cardPaddingV),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Community Guidelines",
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Be respectful and Share your experiences to help others on their journey",
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.2,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for Day Bubbles ---
  Widget _buildDayItem(Map<String, dynamic> data) {
    String day = data['day'];
    String status = data['status'];

    // Determine appearance
    Color bgColor;
    Color textColor;
    Widget? icon;

    if (status == 'clean') {
      bgColor = AppColors.primary;
      textColor = Colors.white;
      icon = const Icon(Icons.check, color: Colors.white, size: 14);
    } else if (status == 'relapse') {
      bgColor = AppColors.error;
      textColor = Colors.white;
      icon = const Icon(Icons.close, color: Colors.white, size: 14);
    } else if (day == 'Mon') {
      bgColor = Colors.orange;
      textColor = Colors.white;
      icon = const Icon(Icons.check, color: Colors.white, size: 14);
    } else {
      bgColor = Colors.white;
      textColor = AppColors.textTertiary;
      icon = null;
    }

    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24, // Smaller bubble
          height: 24,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: status == 'future'
                ? Border.all(color: Colors.white, width: 0)
                : null,
          ),
          child: status == 'future'
              ? Container(
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                )
              : Center(child: icon),
        ),
      ],
    );
  }

  // --- Helper Widgets (Reused) ---
  Widget _buildTopStat(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // reduced
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // reduced
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            "Pro",
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}