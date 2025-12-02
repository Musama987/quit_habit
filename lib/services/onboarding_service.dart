import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  // Reset onboarding (for testing or logout if needed)
  Future<void> resetOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompletedKey);
  }
}
