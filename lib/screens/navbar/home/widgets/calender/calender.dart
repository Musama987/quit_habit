import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quit_habit/services/habit_service.dart';
import 'package:quit_habit/utils/app_colors.dart';

enum CalendarMode { startRoutine, reportRelapse }

class CalendarScreen extends StatefulWidget {
  final CalendarMode mode;
  const CalendarScreen({super.key, this.mode = CalendarMode.reportRelapse});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // State variables
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final HabitService _habitService = HabitService();
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
      );
    });
  }

  Future<void> _handleAction() async {
    if (_userId == null) return;

    try {
      if (widget.mode == CalendarMode.startRoutine) {
        await _habitService.setStartDate(_userId!, _selectedDate);
      } else {
        // For reporting relapse, we might want to redirect to RelapseScreen or keep simple here.
        // Given the previous change to use RelapseScreen, maybe we should just use that?
        // But for now, let's keep the simple action or maybe redirect.
        // The user said "in calnder also they show all status".
        // If this is "Report Relapse" mode, maybe we should just call the simple report or open the new screen?
        // Let's stick to the simple report for now as per previous logic, or maybe just update the status.
        // Actually, the user's flow seems to be: Home -> Relapse Button -> Relapse Screen.
        // This Calendar is mostly for viewing history now, or setting start date.
        // If mode is reportRelapse, let's just add it (simple) or maybe we shouldn't have this button here if it's just for viewing?
        // But the user might want to report a PAST relapse.
        await _habitService.reportRelapse(_userId!, _selectedDate);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isStartMode = widget.mode == CalendarMode.startRoutine;

    if (_userId == null) {
      return const Scaffold(body: Center(child: Text("Please log in")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _habitService.getUserHabitStream(_userId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final Timestamp? startDateTs = data?['startDate'] as Timestamp?;
        final List<dynamic> relapseDatesRaw =
            data?['relapseDates'] as List<dynamic>? ?? [];

        final DateTime? startDate = startDateTs?.toDate();
        final List<DateTime> relapseDates = relapseDatesRaw
            .map((e) => (e as Timestamp).toDate())
            .toList();

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            title: Text(isStartMode ? "Set Start Date" : "Calendar"),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        // --- 1. Legend ---
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
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
                              _buildLegendItem(
                                "Selected",
                                AppColors.textSecondary.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- 2. Month Header ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                color: AppColors.textSecondary,
                              ),
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
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () => _changeMonth(1),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // --- 3. Days of Week ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                                  .map(
                                    (day) => Expanded(
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
                                    ),
                                  )
                                  .toList(),
                        ),

                        const SizedBox(height: 12),

                        // --- 4. Calendar Grid ---
                        _buildCalendarGrid(startDate, relapseDates),
                      ],
                    ),
                  ),
                ),

                // --- 5. Bottom Details Section ---
                _buildBottomDetails(
                  textTheme,
                  isStartMode,
                  startDate,
                  relapseDates,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid(DateTime? startDate, List<DateTime> relapseDates) {
    final int daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final int firstWeekday = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday;
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
        if (index < offset) return const SizedBox();

        final int day = index - offset + 1;
        final DateTime date = DateTime(
          _focusedMonth.year,
          _focusedMonth.month,
          day,
        );
        final bool isSelected = DateUtils.isSameDay(date, _selectedDate);

        // Determine status
        String? status;
        if (startDate != null) {
          // Check if date is before start date (ignore time)
          final start = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          );
          if (!date.isBefore(start) && !date.isAfter(DateTime.now())) {
            // It's in the active range (start date to today)
            bool isRelapse = relapseDates.any(
              (d) =>
                  d.year == date.year &&
                  d.month == date.month &&
                  d.day == date.day,
            );
            status = isRelapse ? 'relapse' : 'clean';
          }
        }

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
                fontWeight: (isSelected || status != null)
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomDetails(
    TextTheme textTheme,
    bool isStartMode,
    DateTime? startDate,
    List<DateTime> relapseDates,
  ) {
    bool isRelapseDay = false;
    if (startDate != null) {
      isRelapseDay = relapseDates.any(
        (d) =>
            d.year == _selectedDate.year &&
            d.month == _selectedDate.month &&
            d.day == _selectedDate.day,
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: const BoxDecoration(color: AppColors.backgroundLight),
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
                      child: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Date",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
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
                    ),
                  ],
                ),
                if (!isStartMode) ...[
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        isRelapseDay ? Icons.error_outline : Icons.check_circle,
                        color: isRelapseDay
                            ? AppColors.error
                            : AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isRelapseDay
                            ? "Relapse reported on this day"
                            : "No relapses on this day",
                        style: TextStyle(
                          color: isRelapseDay
                              ? AppColors.error
                              : AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: isStartMode
                    ? AppColors.primary
                    : AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(isStartMode ? "Set Start Date" : "Report Relapse"),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]}, ${date.year}";
  }

  String _formatFullDate(DateTime date) {
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
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
