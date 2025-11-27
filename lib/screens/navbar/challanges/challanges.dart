import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  // Toggle State: true = Active, false = Available
  bool _isActiveTab = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          // Reduced padding for compactness
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Compact Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Challenges",
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 24, // Reduced from 28
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2), // Reduced spacing
                      Text(
                        "Push your limits, earn rewards",
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 13, // Smaller subtitle
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Compact Pro Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "Pro",
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 11, // Smaller text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16), // Reduced spacing

              // --- 2. Compact Badge Collection ---
              _buildBadgeCollection(textTheme),

              const SizedBox(height: 16), // Reduced spacing

              // --- 3. Compact Toggle Button ---
              Container(
                height: 44, // Fixed compact height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    _buildToggleButton("Active", true),
                    _buildToggleButton("Available", false),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Reduced spacing

              // --- 4. Dynamic Content ---
              _isActiveTab
                  ? _buildActiveContent(textTheme)
                  : _buildAvailableContent(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildToggleButton(String text, bool isForActiveTab) {
    bool isSelected = _isActiveTab == isForActiveTab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isActiveTab = isForActiveTab;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10), // Slightly smaller radius
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13, // Compact font
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCollection(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Badge Collection",
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "2/6 earned",
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadgeItem("First Day", Icons.star, true, Colors.amber[100]!,
                  Colors.amber),
              _buildBadgeItem("3 Days", Icons.auto_awesome, true,
                  Colors.blue[50]!, Colors.blue),
              _buildBadgeItem("Week 1", Icons.bolt, false, Colors.orange[50]!,
                  Colors.orange[200]!),
              _buildBadgeItem("Month 1", Icons.emoji_events, false,
                  Colors.grey[100]!, Colors.grey[300]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(
      String label, IconData icon, bool earned, Color bg, Color iconColor) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50, // Reduced from 64
              height: 50, // Reduced from 64
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26, // Reduced from 32
              ),
            ),
            if (earned)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10, // Smaller text
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- View: ACTIVE Tab Content ---
  Widget _buildActiveContent(TextTheme textTheme) {
    return Column(
      key: const ValueKey("Active"), // Key needed for animation
      children: [
        // 7-Day Warrior Card
        Container(
          padding: const EdgeInsets.all(16), // Reduced padding
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [AppColors.softShadow],
            border: const Border(
                left: BorderSide(
                    color: AppColors.textPrimary, width: 4)), // Dark accent
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.track_changes,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "7-Day Warrior",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Stay smoke-free for 7 consecutive days",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Progress",
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                  Text("71%",
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.71,
                  minHeight: 6, // Thinner bar
                  backgroundColor: AppColors.backgroundLight,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200, width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.emoji_events, color: Color(0xFFD97706), size: 14),
                    SizedBox(width: 6),
                    Text(
                      "Reward: First Week Badge",
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: 12), // Reduced spacing

        _buildFreeModeCard(textTheme),
      ],
    );
  }

  // --- View: AVAILABLE Tab Content ---
  Widget _buildAvailableContent(TextTheme textTheme) {
    return Column(
      key: const ValueKey("Available"), // Key needed for animation
      children: [
        _buildChallengeRow(
          title: "First Month Victory",
          subtitle: "Complete your first 30 days without smoking",
          icon: Icons.emoji_events_outlined,
          iconColor: Colors.green,
          bgIconColor: const Color(0xFFDCFCE7),
          days: "30 days",
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 12),
        _buildChallengeRow(
          title: "Partner Challenge",
          subtitle: "Complete 30 days with a friend for extra motivation",
          icon: Icons.people_outline,
          iconColor: Colors.teal,
          bgIconColor: const Color(0xFFCCFBF1),
          days: "30 days",
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 12),
        _buildChallengeRow(
          title: "Health Champion",
          subtitle: "Track daily health improvements for 14 days",
          icon: Icons.favorite_border,
          iconColor: Colors.teal,
          bgIconColor: const Color(0xFFD1FAE5),
          days: "14 days",
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 12),
        _buildChallengeRow(
          title: "Money Saver",
          subtitle: "Save \$100 by not buying cigarettes",
          icon: Icons.savings_outlined,
          iconColor: Colors.green,
          bgIconColor: const Color(0xFFDCFCE7),
          days: "30 days",
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 12),
        _buildFreeModeCard(textTheme),
      ],
    );
  }

  Widget _buildChallengeRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgIconColor,
    required String days,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44, // Reduced size
          height: 44,
          decoration: BoxDecoration(
            color: bgIconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    days,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: const [
                        Text(
                          "Start",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward,
                            size: 12, color: AppColors.primary)
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFreeModeCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.all_inclusive, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Free Mode",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Track your progress without challenges.",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.7),
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
}