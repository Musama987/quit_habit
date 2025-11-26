import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // State variables
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  // Mock data to simulate status: 'clean', 'relapse', or null
  final Map<String, String> _dayStatus = {
    // Example: 2 days ago was a relapse
    _dateKey(DateTime.now().subtract(const Duration(days: 2))): 'relapse',
    // Example: Yesterday was clean
    _dateKey(DateTime.now().subtract(const Duration(days: 1))): 'clean',
    // Example: Today is selected (handled by _selectedDate logic)
  };

  // Helper to create map keys
  static String _dateKey(DateTime date) => "${date.year}-${date.month}-${date.day}";

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Calendar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // --- 1. Legend ---
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [AppColors.softShadow],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem("Clean Day", AppColors.primary),
                          _buildLegendItem("Relapse", AppColors.error),
                          _buildLegendItem("Selected", AppColors.textSecondary.withOpacity(0.5)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- 2. Month Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Row(
                          children: [
                            Text(
                              _formatMonthYear(_focusedMonth),
                              style: textTheme.displayMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // --- 3. Days of Week ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                          .map((day) => Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 12),

                    // --- 4. Calendar Grid ---
                    _buildCalendarGrid(),
                  ],
                ),
              ),
            ),

            // --- 5. Bottom Details Section ---
            _buildBottomDetails(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final int daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final int firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;
    // DateTime.weekday returns 1 for Mon... 7 for Sun. We want 0 for Sun... 6 for Sat.
    // If Sunday (7), offset is 0. If Mon (1), offset is 1.
    final int offset = firstWeekday == 7 ? 0 : firstWeekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth + offset,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < offset) return const SizedBox(); // Empty padding cells

        final int day = index - offset + 1;
        final DateTime date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
        final bool isSelected = DateUtils.isSameDay(date, _selectedDate);
        final String? status = _dayStatus[_dateKey(date)];

        // Determine styling based on state
        Color bgColor = Colors.transparent;
        Color textColor = AppColors.textPrimary;
        BoxShape shape = BoxShape.rectangle;
        BorderRadius? borderRadius;

        if (isSelected) {
          bgColor = AppColors.primary; // Blue Circle for Selected
          textColor = Colors.white;
          shape = BoxShape.circle;
        } else if (status == 'relapse') {
          bgColor = AppColors.error; // Red Rounded Square for Relapse
          textColor = Colors.white;
          borderRadius = BorderRadius.circular(10);
        } else if (status == 'clean') {
          bgColor = AppColors.primary; // Blue Rounded Square for Clean
          textColor = Colors.white;
          borderRadius = BorderRadius.circular(10);
        }

        return GestureDetector(
          onTap: () => _onDaySelected(date),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              shape: shape,
              borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
            ),
            child: Text(
              "$day",
              style: TextStyle(
                color: textColor,
                fontWeight: (isSelected || status != null) ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomDetails(TextTheme textTheme) {
    final bool isRelapseDay = _dayStatus[_dateKey(_selectedDate)] == 'relapse';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
      ),
      child: Column(
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppColors.softShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Date",
                          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          _formatFullDate(_selectedDate),
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      isRelapseDay ? Icons.error_outline : Icons.check_circle,
                      color: isRelapseDay ? AppColors.error : AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRelapseDay ? "Relapse reported on this day" : "No relapses on this day",
                      style: TextStyle(
                        color: isRelapseDay ? AppColors.error : AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Logic to add relapse for the selected date
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text("Add Relapse"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${months[date.month - 1]}, ${date.year}";
  }

  String _formatFullDate(DateTime date) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}