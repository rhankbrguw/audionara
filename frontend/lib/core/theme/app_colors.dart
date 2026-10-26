// Brand palette constants — single source of truth for all color decisions.
// Never reference Colors.* or raw hex values outside this file.
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF8B5CF6); // Vibrant Purple
  static const Color secondary = Color(0xFFF472B6); // Hot Pink Accent
  static const Color accent = Color(0xFFC084FC); // Soft Purple
  static const Color surface = Color(0xFF1E1E2E); // Premium Dark Surface
  static const Color surfaceVariant = Color(0xFF2A2A3C); // Elevated Surface
  static const Color background = Color(0xFF13131A); // Deepest Background
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFF8FAFC); // Crisp White Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8); // Slate Gray Text
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textInverse70 = Color(0xB3FFFFFF); // white @ 70%

  // Semantic utility tokens — use these instead of Colors.*
  static const Color transparent = Color(0x00000000);
  static const Color shadow = Color(0x42000000); // black @ ~26%
  static const Color shadowMedium = Color(0x4D000000); // black @ ~30%
  static const Color glassOverlay = Color(0x26FFFFFF); // white @ ~15%
  static const Color glassBorder = Color(0x1AFFFFFF); // white @ ~10%
  static const Color borderSubtle = Color(0x33FFFFFF); // white @ 20%

  static const Color error = Color(0xFFFF5252); // redAccent equivalent
  static const Color success = Color(0xFF4CAF50); // green equivalent

  // Vibe Palette Tokens
  static const Color vibeSynthwave1 = Color(0xFF8A2387);
  static const Color vibeSynthwave2 = Color(0xFFE94057);
  static const Color vibeLofi1 = Color(0xFFF2709C);
  static const Color vibeLofi2 = Color(0xFFFF9472);
  static const Color vibeFocus1 = Color(0xFF4CA1AF);
  static const Color vibeFocus2 = Color(0xFFC4E0E5);
  static const Color vibeWorkout1 = Color(0xFFFF416C);
  static const Color vibeWorkout2 = Color(0xFFFF4B2B);
  static const Color vibeAcoustic1 = Color(0xFF1D976C);
  static const Color vibeAcoustic2 = Color(0xFF93F9B9);
  static const Color vibeNight1 = Color(0xFF0F2027);
  static const Color vibeNight2 = Color(0xFF2C5364);

  static const List<Color> primaryGradient = [primary, accent];
}
