import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

    // Responsive sizing
    final double sectionSpacing = isSmallScreen ? 16.0 : 24.0;
    final double cardPadding = isSmallScreen ? 16.0 : 20.0;
    final double avatarSize = isSmallScreen ? 60.0 : 70.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          physics: const BouncingScrollPhysics(),
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
                  fontSize: 13,
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
                        // Avatar with Edit Icon
                        Stack(
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(Icons.person,
                                  color: Colors.white, size: avatarSize * 0.55),
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
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.edit,
                                    size: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sarah Johnson",
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Free Account",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Member since Oct 2025",
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(context, "7", "Day Streak", isSmallScreen),
                        _buildVerticalDivider(isSmallScreen),
                        _buildStatItem(context, "2", "Badges", isSmallScreen),
                        _buildVerticalDivider(isSmallScreen),
                        _buildStatItem(context, "100%", "Success", isSmallScreen),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // Upgrade Button
                    Container(
                      width: double.infinity,
                      height: 44, // Compact height
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.premium.withOpacity(0.3),
                            blurRadius: 8,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Upgrade to Pro",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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

              // --- 2. Quick Actions Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(context, Icons.shield_outlined, "Badges", false, isSmallScreen),
                  _buildQuickAction(context, Icons.bar_chart_rounded, "Stats", false, isSmallScreen),
                  _buildQuickAction(context, Icons.menu_book_outlined, "Learn", false, isSmallScreen),
                  _buildQuickAction(context, Icons.settings_outlined, "Settings", true, isSmallScreen), // Highlighted
                ],
              ),

              SizedBox(height: sectionSpacing),

              // --- 3. Settings Section ---
              Text(
                "Settings",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Compact List Items
              _buildSettingTile(
                context,
                icon: Icons.notifications_outlined,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
                title: "Notifications",
                subtitle: "Manage notification preferences",
                isSmall: isSmallScreen,
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                icon: Icons.lock_outline,
                iconBg: const Color(0xFFF1F5F9),
                iconColor: const Color(0xFF64748B),
                title: "Privacy",
                subtitle: "Control your data and privacy",
                isSmall: isSmallScreen,
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                icon: Icons.person_outline,
                iconBg: const Color(0xFFE0F2FE),
                iconColor: AppColors.primary,
                title: "Account",
                subtitle: "Manage your account settings",
                isSmall: isSmallScreen,
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                icon: Icons.chat_bubble_outline,
                iconBg: const Color(0xFFF3F4F6),
                iconColor: AppColors.textSecondary,
                title: "Help & Support",
                subtitle: "Get help and contact support",
                isSmall: isSmallScreen,
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                icon: Icons.info_outline,
                iconBg: const Color(0xFFE0F7FA),
                iconColor: Colors.cyan,
                title: "About",
                subtitle: "App version and information",
                isSmall: isSmallScreen,
              ),

              const SizedBox(height: 24),

              // --- 4. Sign Out Button ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton.icon(
                  onPressed: () {
                    // Sign out logic
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error, size: 20),
                  label: const Text(
                    "Sign Out",
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
              
              // Bottom padding for navbar
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildStatItem(BuildContext context, String value, String label, bool isSmall) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: isSmall ? 18 : 20,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isSmall) {
    return Container(
      height: isSmall ? 24 : 30,
      width: 1,
      color: AppColors.border,
    );
  }

  Widget _buildQuickAction(
      BuildContext context, IconData icon, String label, bool isSelected, bool isSmall) {
    final double boxSize = isSmall ? 65.0 : 75.0;
    
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
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
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ],
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
      padding: EdgeInsets.all(isSmall ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
        ],
      ),
    );
  }
}