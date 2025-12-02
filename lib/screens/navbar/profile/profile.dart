import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

import 'package:quit_habit/services/auth_service.dart';
import 'package:quit_habit/screens/auth/login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 0: Badges, 1: Stats, 2: Learn, 3: Settings
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

    // Responsive sizing variables - Spacious and Comfortable
    final double sectionSpacing = isSmallScreen ? 20.0 : 24.0;
    final double cardPadding = 20.0;
    final double avatarSize = isSmallScreen ? 60.0 : 70.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        // --- COMPLETE SCREEN SCROLL ---
        // The entire content including header scrolls together
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          // physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Text(
                "Profile",
                style: textTheme.displayMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: isSmallScreen ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your journey and achievements",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: sectionSpacing),

              // --- 1. Main Profile Card ---
              Container(
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppColors.softShadow],
                ),
                child: Column(
                  children: [
                    // Avatar & Name
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: avatarSize * 0.55,
                              ),
                            ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AuthService().currentUser?.displayName ??
                                    AuthService().currentUser?.email?.split(
                                      '@',
                                    )[0] ??
                                    "User",
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 18 : 20,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Free Account",
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Member since ${_formatDate(AuthService().currentUser?.metadata.creationTime)}",
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          context,
                          "7",
                          "Day Streak",
                          isSmallScreen,
                        ),
                        _buildVerticalDivider(isSmallScreen),
                        _buildStatItem(context, "2", "Badges", isSmallScreen),
                        _buildVerticalDivider(isSmallScreen),
                        _buildStatItem(
                          context,
                          "100%",
                          "Success",
                          isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Upgrade Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.premium.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Upgrade to Pro",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sectionSpacing),

              // --- 2. Quick Actions Row (Selector) ---
              Row(
                children: [
                  _buildQuickAction(
                    context,
                    Icons.shield_outlined,
                    "Badges",
                    0,
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAction(
                    context,
                    Icons.bar_chart_rounded,
                    "Stats",
                    1,
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAction(
                    context,
                    Icons.menu_book_outlined,
                    "Learn",
                    2,
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAction(
                    context,
                    Icons.settings_outlined,
                    "Settings",
                    3,
                  ),
                ],
              ),

              SizedBox(height: sectionSpacing),

              // --- 3. Dynamic Content Section ---
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildSelectedView(context, textTheme, isSmallScreen),
              ),

              // Bottom padding for navbar clearance
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // --- View Switching Logic ---
  Widget _buildSelectedView(
    BuildContext context,
    TextTheme textTheme,
    bool isSmall,
  ) {
    switch (_selectedIndex) {
      case 0:
        return _buildBadgesView(textTheme);
      case 1:
        return _buildStatsView(textTheme);
      case 2:
        return _buildLearnView(textTheme);
      case 3:
      default:
        return _buildSettingsView(context, textTheme, isSmall);
    }
  }

  // --- A. Badges View ---
  Widget _buildBadgesView(TextTheme textTheme) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Badges",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "2 of 6 earned",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildBadgeCard(
              "First Week",
              "Oct 13",
              Icons.track_changes,
              true,
              Colors.redAccent,
              const Color(0xFFFEF2F2),
            ),
            _buildBadgeCard(
              "Money Saver",
              "Oct 15",
              Icons.savings,
              true,
              Colors.amber,
              const Color(0xFFFFFBEB),
            ),
            _buildBadgeCard(
              "Health Hero",
              "Locked",
              Icons.favorite,
              false,
              Colors.pinkAccent,
              const Color(0xFFFDF2F8),
            ),
            _buildBadgeCard(
              "One Month",
              "Locked",
              Icons.emoji_events,
              false,
              Colors.orange,
              const Color(0xFFFFF7ED),
            ),
            _buildBadgeCard(
              "Team Player",
              "Locked",
              Icons.groups,
              false,
              Colors.blue,
              const Color(0xFFEFF6FF),
            ),
            _buildBadgeCard(
              "Champion",
              "Locked",
              Icons.military_tech,
              false,
              Colors.purple,
              const Color(0xFFFAF5FF),
            ),
          ],
        ),
      ],
    );
  }

  // --- B. Stats View ---
  Widget _buildStatsView(TextTheme textTheme) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Statistics",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                Icons.local_fire_department,
                "7",
                "Total Days",
                const Color(0xFFDCFCE7),
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                Icons.emoji_events,
                "2",
                "Challenges",
                const Color(0xFFF3E8FF),
                AppColors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                Icons.savings,
                "\$36",
                "Money Saved",
                const Color(0xFFE0F2FE),
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                Icons.check_circle,
                "100%",
                "Success Rate",
                const Color(0xFFFCE7F3),
                Colors.pink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppColors.softShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "7-Day Progress",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  7,
                  (index) => Container(
                    width: 24,
                    height: 50.0 + (index * 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["M", "T", "W", "T", "F", "S", "S"]
                    .map(
                      (day) => SizedBox(
                        width: 24,
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- C. Learn View ---
  Widget _buildLearnView(TextTheme textTheme) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Knowledge Base",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _ExpandableLearnItem(
          title: "Why is smoking harmful?",
          icon: Icons.smoke_free,
          color: Colors.grey,
          description:
              "Smoking damages your lungs, heart, and blood vessels. It increases the risk of stroke, heart disease, and lung cancer.",
        ),
        const SizedBox(height: 12),
        _ExpandableLearnItem(
          title: "Health benefits of quitting",
          icon: Icons.favorite,
          color: Colors.redAccent,
          description:
              "Within 20 minutes, your heart rate drops. Within 12 hours, carbon monoxide levels return to normal. Lung function improves within weeks.",
        ),
        const SizedBox(height: 12),
        _ExpandableLearnItem(
          title: "Understanding nicotine addiction",
          icon: Icons.psychology,
          color: Colors.pink,
          description:
              "Nicotine triggers dopamine release, creating a cycle of craving and relief. Breaking this cycle takes time and patience.",
        ),
        const SizedBox(height: 12),
        _ExpandableLearnItem(
          title: "Tips for handling cravings",
          icon: Icons.fitness_center,
          color: Colors.orange,
          description:
              "Drink water, practice deep breathing, go for a walk, or use the 4Ds: Delay, Deep breathe, Drink water, Do something else.",
        ),
        const SizedBox(height: 12),
        _ExpandableLearnItem(
          title: "Success stories",
          icon: Icons.star,
          color: Colors.amber,
          description:
              "Read about how others overcame their addiction and improved their lives through persistence and support.",
        ),
      ],
    );
  }

  // --- D. Settings View ---
  Widget _buildSettingsView(
    BuildContext context,
    TextTheme textTheme,
    bool isSmall,
  ) {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          context,
          icon: Icons.notifications_outlined,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: "Notifications",
          subtitle: "Manage notification preferences",
          isSmall: isSmall,
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          context,
          icon: Icons.lock_outline,
          iconBg: const Color(0xFFF1F5F9),
          iconColor: const Color(0xFF64748B),
          title: "Privacy",
          subtitle: "Control your data and privacy",
          isSmall: isSmall,
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          context,
          icon: Icons.person_outline,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: AppColors.primary,
          title: "Account",
          subtitle: "Manage your account settings",
          isSmall: isSmall,
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          context,
          icon: Icons.chat_bubble_outline,
          iconBg: const Color(0xFFF3F4F6),
          iconColor: AppColors.textSecondary,
          title: "Help & Support",
          subtitle: "Get help and contact support",
          isSmall: isSmall,
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          context,
          icon: Icons.info_outline,
          iconBg: const Color(0xFFE0F7FA),
          iconColor: Colors.cyan,
          title: "About",
          subtitle: "App version and information",
          isSmall: isSmall,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    "Are you sure you want to sign out?",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  actions: [
                    // Cancel Button
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sign Out Button
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog
                        await AuthService().signOut();
                        if (context.mounted) {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout, color: AppColors.error, size: 20),
            label: const Text(
              "Sign Out",
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFEF2F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.error.withOpacity(0.2)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    bool isSmall,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: isSmall ? 18 : 22,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isSmall) {
    return Container(
      height: isSmall ? 24 : 32,
      width: 1,
      color: AppColors.border,
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [AppColors.softShadow],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(height: 6),
              FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isSmall,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(
    String title,
    String date,
    IconData icon,
    bool unlocked,
    Color color,
    Color bg,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.softShadow],
        border: unlocked
            ? Border.all(color: color.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: unlocked ? bg : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: unlocked ? color : Colors.grey[400],
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: unlocked ? AppColors.textPrimary : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color bg,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "2025";
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${months[date.month - 1]} ${date.year}";
  }
}

// --- Expandable Learn Item Widget (Height Increased) ---
class _ExpandableLearnItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const _ExpandableLearnItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  State<_ExpandableLearnItem> createState() => _ExpandableLearnItemState();
}

class _ExpandableLearnItemState extends State<_ExpandableLearnItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppColors.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: widget.color, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 22,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
