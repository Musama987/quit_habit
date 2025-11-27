import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quit_habit/screens/navbar/community/community_comment.dart';
import 'package:quit_habit/screens/navbar/community/community_post.dart';
import 'package:quit_habit/utils/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Mock Data
  final List<Map<String, dynamic>> _posts = [
    {
      'initials': 'SJ',
      'name': 'Sarah Johnson',
      'time': '2 hours ago',
      'streak': 30,
      'content':
          'Just completed my first month smoke-free! 🎉 The breathing exercises really helped during tough moments. Stay strong everyone!',
      'likes': 124,
      'comments': 2,
    },
    {
      'initials': 'MR',
      'name': 'Mike Roberts',
      'time': '4 hours ago',
      'streak': 5,
      'content':
          'The cravings are intense. Anyone for getting through the afternoon slump?',
      'likes': 45,
      'comments': 2,
    },
    {
      'initials': 'AL',
      'name': 'Anna Lee',
      'time': '6 hours ago',
      'streak': 14,
      'content':
          'Two weeks down! I saved \$50 already. Treating myself to a nice dinner tonight.',
      'likes': 89,
      'comments': 5,
    },
    {
      'initials': 'DK',
      'name': 'David Kim',
      'time': '1 day ago',
      'streak': 3,
      'content':
          'Relapsed yesterday but starting fresh today. Failure is part of the journey, right?',
      'likes': 67,
      'comments': 12,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // --- Custom App Bar ---
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        titleSpacing: 20,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            _buildTopStat(Icons.shield_outlined, "0%", Colors.cyan),
            const SizedBox(width: 8),
            _buildTopStat(Icons.diamond_outlined, "1", AppColors.primary),
            const SizedBox(width: 8),
            _buildTopStat(Icons.monetization_on_outlined, "0", Colors.amber),
            const Spacer(),
            _buildProButton(textTheme),
          ],
        ),
      ),
      
      // --- Feed Body ---
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _posts.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  "Load More Posts",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }

          final post = _posts[index];
          return _buildPostCard(textTheme, post);
        },
      ),

      // --- Floating Action Button ---
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () {
            // --- UPDATED NAVIGATION LOGIC ---
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: const CommunityPostScreen(),
              withNavBar: false, // Hide nav bar for full screen effect
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(TextTheme textTheme, Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () {
        // --- Navigate to Detail Screen ---
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: CommunityCommentScreen(post: post),
          withNavBar: false, 
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppColors.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFF3F4F6),
                  child: Text(
                    post['initials'],
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['name'],
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post['time'],
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Streak Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFEDD5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.whatshot, color: Color(0xFFF97316), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${post['streak']}",
                        style: const TextStyle(
                          color: Color(0xFFC2410C),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Content
            Text(
              post['content'],
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),

            // Footer
            Row(
              children: [
                Icon(Icons.favorite_border, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 6),
                Text(
                  "${post['likes']}",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 24),
                Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 6),
                Text(
                  "${post['comments']}",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStat(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            "Pro",
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}