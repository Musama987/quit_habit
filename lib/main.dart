import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quit_habit/firebase_options.dart';
import 'package:quit_habit/screens/auth/login/login.dart';
import 'package:quit_habit/screens/navbar/navbar.dart';
import 'package:quit_habit/screens/onboarding/onboardingone.dart';
import 'package:quit_habit/services/onboarding_service.dart';
import 'package:quit_habit/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      // Setting the AuthWrapper as the home widget
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _isOnboardingCompleted;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _isOnboardingCompleted = await OnboardingService()
          .isOnboardingCompleted();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) {
      return const LoginScreen();
    }

    if (_isOnboardingCompleted == true) {
      return const MainNavBar();
    } else {
      return const OnboardingOneScreen();
    }
  }
}
