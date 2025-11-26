import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quit_habit/screens/navbar/home/widgets/breathing/breathing.dart';
import 'package:quit_habit/screens/navbar/home/widgets/tools/tools.dart';
import 'package:quit_habit/utils/app_colors.dart';
import 'package:quit_habit/screens/navbar/home/widgets/calender/calender.dart';
import 'package:quit_habit/screens/navbar/home/widgets/relapse/relapse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // Custom App Bar to match the top stats row
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
            _buildProButton(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Main Tracker Card
            _buildTrackerCard(textTheme),
            
            const SizedBox(height: 24),

            // 2. Distractions Section
            _buildSectionHeader(
              "Need a Distraction?", 
              showViewAll: true,
              onViewAllPressed: () {
                // Navigate to ToolsScreen when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ToolsScreen()),
                );
              }
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Connected the Breathing Card to navigation
                Expanded(
                  child: _buildDistractionCard(
                    Icons.air, 
                    "Breathing", 
                    const Color(0xFFFFE2E2), 
                    const Color(0xFFEF4444),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BreathingScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildDistractionCard(Icons.show_chart, "Exercise", const Color(0xFFE0F2FE), const Color(0xFF3B82F6))),
                const SizedBox(width: 12),
                Expanded(child: _buildDistractionCard(Icons.self_improvement, "Meditate", const Color(0xFFDCFCE7), const Color(0xFF10B981))),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Weekly Progress
            _buildSectionHeader("Weekly Progress"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppColors.softShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDayBubble("Thu", true, Colors.blue),
                  _buildDayBubble("Fri", true, Colors.red),
                  _buildDayBubble("Sat", true, Colors.blue),
                  _buildDayBubble("Sun", true, Colors.blue),
                  _buildDayBubble("Mon", true, Colors.amber),
                  _buildDayBubble("Tue", false, Colors.grey),
                  _buildDayBubble("Wed", false, Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Active Challenge
            _buildSectionHeader("Active Challenge"),
            const SizedBox(height: 12),
            _buildChallengeCard(textTheme),

            const SizedBox(height: 24),

            // 5. Today's Plan
            _buildSectionHeader("Today's Plan", showViewAll: true),
            const SizedBox(height: 12),
            _buildPlanCard(textTheme),

            const SizedBox(height: 24),

            // 6. Premium Banner
            _buildPremiumCard(textTheme),
            
            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
      // Floating Action Button for Chat
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
          boxShadow: [AppColors.softShadow],
        ),
        child: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
          onPressed: () {},
        ),
      ),
    );
  }

  // --- Widgets Methods ---

  Widget _buildTrackerCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Keep Going!", style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: "Day ",
              style: textTheme.displayMedium?.copyWith(color: AppColors.textPrimary, fontSize: 28),
              children: [
                TextSpan(text: "34", style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900, fontSize: 34)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF374151)), // Dark grey as per image
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalendarScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Complete", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RelapseScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text("Relapse", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Updated to include onTap for navigation
  Widget _buildDistractionCard(IconData icon, String label, Color bg, Color iconColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // Trigger navigation if provided
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBubble(String day, bool isChecked, Color color) {
    bool isPending = !isChecked && color != Colors.grey; // Logic for the checkmark/cross
    bool isEmpty = color == Colors.grey;

    return Column(
      children: [
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isEmpty ? Colors.grey[100] : color,
            shape: BoxShape.circle,
          ),
          child: isEmpty
              ? null
              : Icon(
                  color == Colors.blue ? Icons.check : (color == Colors.amber ? Icons.check : Icons.close),
                  color: Colors.white,
                  size: 20,
                ),
        ),
      ],
    );
  }

 Widget _buildChallengeCard(TextTheme textTheme) {
    return Container(
      // 1. Outer Container: Creates the Gradient Border Effect
      decoration: BoxDecoration(
        // This gradient goes from Blue (Left) to White (Right), creating the left-side glow
        gradient: const LinearGradient(
          colors: [AppColors.primary, Colors.white], 
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.01, 0.01], // Adjusts how far the blue fades across the border
        ),
        borderRadius: BorderRadius.circular(24), // Outer radius
        boxShadow: [AppColors.softShadow],
      ),
      padding: const EdgeInsets.all(6), // This padding determines the border width (2px)
      
      child: Container(
        // 2. Inner Container: The actual white card content
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22), // Inner radius (Outer - Padding)
        ),
        child: Column(
          children: [
            // Icon Background
            Container(
              width: 56, // Slightly larger touch target
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight, // Very light blue background
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 30),
            ),
            const SizedBox(height: 12),
            
            // Title
            Text(
              "7-Day Warrior", 
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppColors.textPrimary
              )
            ),
            const SizedBox(height: 6),
            
            // Subtitle
            Text(
              "Stay smoke-free for 7 consecutive days", 
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
                fontSize: 13,
              ), 
              textAlign: TextAlign.center
            ),
            
            const SizedBox(height: 24),
            
            // Progress Section
            Row(
              children: [
                Text(
                  "Progress", 
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary, 
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                  )
                ),
                const Spacer(),
                Text(
                  "71%", 
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.textPrimary, 
                    fontSize: 13
                  )
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.71, 
                minHeight: 8, 
                backgroundColor: Color(0xFFF3F4F6), 
                valueColor: AlwaysStoppedAnimation(AppColors.primary)
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPlanCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [AppColors.softShadow]),
      child: Column(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFDCFCE7), child: Icon(Icons.spa, color: AppColors.success, size: 20)),
          const SizedBox(height: 8),
          Text("Day 3 • Active", style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 16),
          _buildCheckItem("Make commitment to quit smoking day by day.", true),
          const SizedBox(height: 12),
          _buildCheckItem("Establish immediate health benefits with quit habit", false),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, bool isChecked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(isChecked ? Icons.check_circle : Icons.circle, color: isChecked ? AppColors.success : Colors.grey[300], size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
      ],
    );
  }

  Widget _buildPremiumCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [AppColors.softShadow]),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.premium, size: 32),
          const SizedBox(height: 8),
          Text("Unlock Premium", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Get unlimited challenges, advanced analytics,\nand exclusive tools!", textAlign: TextAlign.center, style: textTheme.bodyMedium?.copyWith(fontSize: 12)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(16)),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text("Upgrade to Pro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Updated to accept an optional VoidCallback for custom navigation
  Widget _buildSectionHeader(String title, {bool showViewAll = false, VoidCallback? onViewAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        if (showViewAll)
          TextButton(
            onPressed: onViewAllPressed ?? () {}, // Use callback or empty function
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Row(
              children: [
                Text("View All", style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 12, color: AppColors.primary),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildTopStat(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [Icon(icon, size: 14, color: color), const SizedBox(width: 4), Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color))]),
    );
  }

  Widget _buildProButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(20)),
      child: const Row(children: [Icon(Icons.workspace_premium, color: Colors.white, size: 14), SizedBox(width: 4), Text("Pro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
    );
  }
}