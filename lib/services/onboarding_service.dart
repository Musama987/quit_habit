import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // Check if onboarding is completed for a specific user
  Future<bool> isOnboardingCompleted(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${_onboardingCompletedKey}_$userId') ?? false;
  }

  // Mark onboarding as completed for a specific user
  Future<void> completeOnboarding(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_onboardingCompletedKey}_$userId', true);
  }

  // Reset onboarding (for testing or logout if needed)
  Future<void> resetOnboarding(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_onboardingCompletedKey}_$userId');
  }
}
