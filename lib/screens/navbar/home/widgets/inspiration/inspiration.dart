import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quit_habit/utils/app_colors.dart';

class InspirationScreen extends StatefulWidget {
  const InspirationScreen({super.key});

  @override
  State<InspirationScreen> createState() => _InspirationScreenState();
}

class _InspirationScreenState extends State<InspirationScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Mock Data
  final List<Map<String, dynamic>> _quotes = [
    {
      "text": "The secret of getting ahead is getting started.",
      "author": "Mark Twain",
      "isFavorite": false,
    },
    {
      "text": "It always seems impossible until it is done.",
      "author": "Nelson Mandela",
      "isFavorite": false,
    },
    {
      "text": "Your life does not get better by chance, it gets better by change.",
      "author": "Jim Rohn",
      "isFavorite": false,
    },
    {
      "text": "Believe you can and you're halfway there.",
      "author": "Theodore Roosevelt",
      "isFavorite": false,
    },
    {
      "text": "Don't watch the clock; do what it does. Keep going.",
      "author": "Sam Levenson",
      "isFavorite": false,
    },
    {
      "text": "Strength does not come from physical capacity. It comes from an indomitable will.",
      "author": "Mahatma Gandhi",
      "isFavorite": false,
    },
    {
      "text": "Success is the sum of small efforts, repeated day in and day out.",
      "author": "Robert Collier",
      "isFavorite": false,
    },
    {
      "text": "The only way to do great work is to love what you do.",
      "author": "Steve Jobs",
      "isFavorite": false,
    },
  ];

  int get _favoritesCount =>
      _quotes.where((q) => q['isFavorite'] == true).length;

  void _nextPage() {
    if (_currentIndex < _quotes.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleFavorite() {
    setState(() {
      _quotes[_currentIndex]['isFavorite'] =
          !_quotes[_currentIndex]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // --- 1. Header ---
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Inspiration",
                                  style: textTheme.displayMedium?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  "Daily Motivation",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: AppColors.textSecondary, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- 2. Counters ---
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 70, // Fixed compact height
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${_currentIndex + 1}",
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "of ${_quotes.length}",
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 70, // Fixed compact height
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F2), // Light pinkish
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$_favoritesCount",
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Favorites",
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height:20),

                      // --- 3. Motivation Tag (Added) ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.menu_book_rounded,
                                color: AppColors.primary, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "Motivation",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // --- 4. Quote Card (Compact) ---
                      // Removed Expanded to prevent overflow errors in Column
                      SizedBox(
                        height: 240, // Fixed reasonable height for text
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemCount: _quotes.length,
                          itemBuilder: (context, index) {
                            final quote = _quotes[index];
                            return Container(
                              // Margin to separate pages visually slightly
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 20.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.format_quote_rounded,
                                      color: AppColors.primary, size: 32),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          quote['text'],
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.inter(
                                            fontSize: 18, // Slightly smaller
                                            height: 1.3,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                            color: const Color(0xFF1E293B),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "— ${quote['author']}",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // --- 5. Action Buttons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _toggleFavorite,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                _quotes[_currentIndex]['isFavorite']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _quotes[_currentIndex]['isFavorite']
                                    ? AppColors.error
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.share_outlined,
                                  color: AppColors.textSecondary, size: 22),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- 6. Navigation (Arrows & Dots) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Arrow
                          GestureDetector(
                            onTap: _prevPage,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color: _currentIndex > 0
                                    ? AppColors.textPrimary
                                    : AppColors.textTertiary,
                                size: 24,
                              ),
                            ),
                          ),

                          // Dots Indicator
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(_quotes.length, (index) {
                              // Logic to show a window of dots if list is long, or just max 5
                              if (_quotes.length > 5) {
                                // Simple logic: show first 5, but update active
                                // Real implementation might be complex, sticking to simple row for "compact" request
                                if (index >= 5) return const SizedBox.shrink();
                              }
                              
                              bool isActive = _currentIndex == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: 8, // Keep them circles as per image mostly
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primary // Active Color
                                      : AppColors.border, // Inactive Color
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),

                          // Right Arrow (Blue Circle)
                          GestureDetector(
                            onTap: _nextPage,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x403B82F6),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: const Icon(Icons.chevron_right,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),
                      
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("💫", style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Read one inspiring message daily to reinforce your commitment. Save favorites to revisit when motivation is low.",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                                // Ensure text doesn't get cut off
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}