import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // -- Brand Colors --
  static const Color primary = Color(0xFF3B82F6); // Bright Royal Blue (Main Actions)
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF); // Very light blue for backgrounds

  // -- Accent Colors --
  static const Color purple = Color(0xFF8B5CF6); // Onboarding progress bars
  static const Color purpleLight = Color(0xFFF3E8FF);
  
  static const Color premium = Color(0xFFFF9900); // "Pro" Orange/Gold
  static const Color premiumDark = Color(0xFFF57C00);
  
  static const Color success = Color(0xFF10B981); // Green/Clean days
  static const Color successLight = Color(0xFFD1FAE5);
  
  static const Color error = Color(0xFFEF4444); // Red/Relapse
  static const Color errorLight = Color(0xFFFEE2E2);

  // -- Text Colors --
  static const Color textPrimary = Color(0xFF1F2937); // Almost Black (Headings)
  static const Color textSecondary = Color(0xFF6B7280); // Grey (Subtitles)
  static const Color textTertiary = Color(0xFF9CA3AF); // Light Grey (Placeholders)
  static const Color white = Color(0xFFFFFFFF);

  // -- Background Colors --
  static const Color backgroundLight = Color(0xFFF8FAFC); // Very subtle grey-blue (Scaffold)
  static const Color surfaceLight = Color(0xFFFFFFFF); // Cards
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0); // Light borders

  // -- Dark Mode Colors (Inferred) --
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color borderDark = Color(0xFF374151);

  // -- Gradients --
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFFFA726), Color(0xFFFF6D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFC084FC), Color(0xFF8B5CF6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // -- Shadows --
  static BoxShadow softShadow = BoxShadow(
    color: const Color(0xFF64748B).withOpacity(0.08),
    spreadRadius: 0,
    blurRadius: 20,
    offset: const Offset(0, 4),
  );
}