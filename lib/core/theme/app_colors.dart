import 'package:flutter/material.dart';

/// HunarDaily color palette:
/// - Light Theme: Teal/Emerald primary accents on calm Warm Off-White surfaces.
/// - Dark Theme: High-contrast Teal/Emerald highlights on Dark Slate surfaces.
class AppColors {
  const AppColors._();

  // Light Theme (Teal / Emerald + Off-White)
  static const Color lightPrimary = Color(0xFF0F766E);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFCCFBF1);
  static const Color lightOnPrimaryContainer = Color(0xFF064E3B);

  static const Color lightSecondary = Color(0xFF059669);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFD1FAE5);
  static const Color lightOnSecondaryContainer = Color(0xFF065F46);

  static const Color lightBackground = Color(0xFFF8FAF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEFF5F3);
  static const Color lightOnSurface = Color(0xFF0F172A);
  static const Color lightOnSurfaceMuted = Color(0xFF475569);
  static const Color lightOutline = Color(0xFFCBD5E1);

  // Dark Theme (Dark Slate + Bright Teal/Emerald)
  static const Color darkPrimary = Color(0xFF2DD4BF);
  static const Color darkOnPrimary = Color(0xFF042F2E);
  static const Color darkPrimaryContainer = Color(0xFF115E59);
  static const Color darkOnPrimaryContainer = Color(0xFFCCFBF1);

  static const Color darkSecondary = Color(0xFF34D399);
  static const Color darkOnSecondary = Color(0xFF022C22);
  static const Color darkSecondaryContainer = Color(0xFF065F46);
  static const Color darkOnSecondaryContainer = Color(0xFFD1FAE5);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF273449);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkOnSurfaceMuted = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF334155);

  // Semantic accents
  static const Color warningBgLight = Color(0xFFFEF3C7);
  static const Color warningFgLight = Color(0xFF92400E);
  static const Color warningBgDark = Color(0xFF451A03);
  static const Color warningFgDark = Color(0xFFFDE68A);

  static const Color errorLight = Color(0xFFB91C1C);
  static const Color errorDark = Color(0xFFFCA5A5);
}
