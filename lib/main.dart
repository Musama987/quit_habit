import 'package:flutter/material.dart';
import 'package:quit_habit/screens/auth/login/login.dart';
import 'package:quit_habit/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quit Habit',
      // Apply the custom light theme
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // Setting the LoginScreen as the home widget
      home: const LoginScreen(),
    );
  }
}

// Removing MyHomePage and _MyHomePageState as they are the default counter app components
// and are no longer relevant for the new functionality.