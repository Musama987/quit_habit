import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quit_habit/screens/navbar/home/home.dart';
// import 'package:quit_habit/screens/navbar/home/widgets/tools/tools.dart';
import 'package:quit_habit/utils/app_colors.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const _PlaceholderScreen(title: 'challanges'),
      const _PlaceholderScreen(title: 'Community'),
      const _PlaceholderScreen(title: 'Plan'),
      const _PlaceholderScreen(title: 'Profile'),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _buildNavItem(Icons.home, Icons.home_outlined, "Home"),
      _buildNavItem(Icons.track_changes, Icons.track_changes_outlined, "Challanges"),
      _buildNavItem(Icons.people, Icons.people, "Community"),
      _buildNavItem(Icons.calendar_month, Icons.calendar_today_outlined, "Plan"),
      _buildNavItem(Icons.person, Icons.person_outline, "Profile"),
    ];
  }

  PersistentBottomNavBarItem _buildNavItem(IconData activeIcon, IconData inactiveIcon, String title) {
    return PersistentBottomNavBarItem(
      icon: Icon(activeIcon, size: 22), // Slightly smaller icon to save space
      inactiveIcon: Icon(inactiveIcon, size: 22),
      title: title,
      activeColorPrimary: AppColors.primary,
      inactiveColorPrimary: AppColors.textSecondary,
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      
      // --- FIXES ---
      // 1. Use EdgeInsets instead of NavBarPadding
      padding: const EdgeInsets.only(top: 8, bottom: 8), 
      
      // 2. Reduced height to bring text and icon closer
      navBarHeight: 60, 
      
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      navBarStyle: NavBarStyle.style6, 
      backgroundColor: Colors.white,
    );
  }
}

// Placeholder for other tabs
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.displayMedium),
      ),
    );
  }
}