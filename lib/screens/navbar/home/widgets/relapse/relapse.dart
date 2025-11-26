import 'package:flutter/material.dart';
import 'package:quit_habit/utils/app_colors.dart';

class RelapseScreen extends StatefulWidget {
  const RelapseScreen({super.key});

  @override
  State<RelapseScreen> createState() => _RelapseScreenState();
}

class _RelapseScreenState extends State<RelapseScreen> {
  // State variables
  DateTime _selectedDate = DateTime.now();
  int? _selectedTriggerIndex;
  bool _coinPenaltyEnabled = true;

  // Data for the grid options
  final List<Map<String, dynamic>> _triggers = [
    {'icon': '😓', 'label': 'Stress or anxiety'},
    {'icon': '👥', 'label': 'Social pressure'},
    {'icon': '😐', 'label': 'Boredom'},
    {'icon': '🎉', 'label': 'Celebration/Party'},
    {'icon': '🔄', 'label': 'Old habits/routine'},
    {'icon': '❓', 'label': 'Other reason', 'isCustom': true},
  ];

  // Helper to format date simply without external package
  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header Section ---
            _buildHeader(context, textTheme),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Date Selector ---
                    _buildDateSelector(textTheme),

                    const SizedBox(height: 24),

                    // --- Trigger Selection ---
                    Text(
                      "What triggered this relapse?",
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTriggerGrid(),

                    const SizedBox(height: 24),

                    // --- Coin Penalty Card ---
                    _buildCoinPenaltyCard(textTheme),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // --- Bottom Buttons ---
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.5),
        border: const Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error, // Using existing error red
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Report Relapse",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "It's okay, setbacks happen. Let's learn from this.",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(TextTheme textTheme) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [AppColors.softShadow],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Relapse Date",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(_selectedDate),
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6, // Adjust for card shape
      ),
      itemCount: _triggers.length,
      itemBuilder: (context, index) {
        final trigger = _triggers[index];
        final isSelected = _selectedTriggerIndex == index;
        final bool isCustom = trigger['isCustom'] ?? false;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTriggerIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isCustom
                    ? Text(
                        trigger['icon'],
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.error, // Red Question mark
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        trigger['icon'],
                        style: const TextStyle(fontSize: 24),
                      ),
                const SizedBox(height: 8),
                Text(
                  trigger['label'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoinPenaltyCard(TextTheme textTheme) {
    // Using a custom light orange color for the penalty card background
    // mimicking the design in the image
    const Color penaltyBg = Color(0xFFFFF7ED); 
    const Color penaltyBorder = Color(0xFFFFEDD5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: penaltyBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: penaltyBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_filled, // Using similar clock/coin icon
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Coin Penalty",
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "10 coins will be deducted",
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _coinPenaltyEnabled,
                activeColor: Colors.deepOrange,
                onChanged: (value) {
                  setState(() {
                    _coinPenaltyEnabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: penaltyBorder),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.deepOrange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "This helps you stay accountable to your recovery journey",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle Confirm Logic Here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}