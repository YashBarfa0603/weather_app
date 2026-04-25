import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class SkyCastColors {

  static const darkSurface = Color(0xFF0A0E21);
  static const darkSurfaceContainer = Color(0xFF141829);
  static const darkSurfaceContainerHigh = Color(0xFF1C2033);
  static const darkSurfaceContainerHighest = Color(0xFF252A3D);
  static const darkOnSurface = Color(0xFFE8E8EE);
  static const darkOnSurfaceVariant = Color(0xFFA0A4B8);
  static const darkOutline = Color(0xFF3A3F55);


  static const lightSurface = Color(0xFFF5F7FA);
  static const lightSurfaceContainer = Color(0xFFEBEEF5);
  static const lightSurfaceContainerHigh = Color(0xFFE1E5EF);
  static const lightSurfaceContainerHighest = Color(0xFFD7DCE9);
  static const lightOnSurface = Color(0xFF1A1D2E);
  static const lightOnSurfaceVariant = Color(0xFF5A5E72);
  static const lightOutline = Color(0xFFC4C8D8);


  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF8B83FF);
  static const secondary = Color(0xFF00D2FF);
  static const tertiary = Color(0xFFFF6B6B);
  static const amber = Color(0xFFFFB74D);
  static const green = Color(0xFF4CAF50);
  static const teal = Color(0xFF26A69A);
}


class WeatherGradients {
  static LinearGradient getGradient(String condition, bool isDark, {DateTime? time}) {
    final hour = time?.hour ?? DateTime.now().hour;
    final isNight = hour < 6 || hour > 19;

    if (isNight && isDark) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A0E21), Color(0xFF1A1040), Color(0xFF0A0E21)],
      );
    }

    final lowerCondition = condition.toLowerCase();

    if (lowerCondition.contains('clear') || lowerCondition.contains('sunny')) {
      return isDark
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF01579B)],
            )
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF42A5F5), Color(0xFF64B5F6), Color(0xFFBBDEFB)],
            );
    }

    if (lowerCondition.contains('cloud')) {
      return isDark
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1F3A), Color(0xFF2C3150), Color(0xFF1A1F3A)],
            )
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF90A4AE), Color(0xFFB0BEC5), Color(0xFFCFD8DC)],
            );
    }

    if (lowerCondition.contains('rain') || lowerCondition.contains('drizzle')) {
      return isDark
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1B2E), Color(0xFF263238), Color(0xFF1A1B2E)],
            )
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF78909C), Color(0xFF90A4AE), Color(0xFFB0BEC5)],
            );
    }

    if (lowerCondition.contains('thunder') || lowerCondition.contains('storm')) {
      return isDark
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0A2E), Color(0xFF2D1B4E), Color(0xFF1A0A2E)],
            )
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF616161), Color(0xFF78909C), Color(0xFF90A4AE)],
            );
    }

    if (lowerCondition.contains('snow')) {
      return isDark
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1C2541), Color(0xFF3A506B), Color(0xFF1C2541)],
            )
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE0E0E0), Color(0xFFEEEEEE), Color(0xFFF5F5F5)],
            );
    }

    if (lowerCondition.contains('mist') || lowerCondition.contains('fog') || lowerCondition.contains('haze')) {
      return isDark
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E2233), Color(0xFF2A3040), Color(0xFF1E2233)],
            )
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBDBDBD), Color(0xFFCFD8DC), Color(0xFFE0E0E0)],
            );
    }

    // Default
    return isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF1A1F3A), Color(0xFF0A0E21)],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF64B5F6), Color(0xFF90CAF9), Color(0xFFBBDEFB)],
          );
  }
}


class GlassDecoration {
  static BoxDecoration card({required bool isDark, double opacity = 0.12, double radius = 16}) {
    return BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: opacity)
          : Colors.white.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.8),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration pill({required bool isDark}) {
    return BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.9),
        width: 1,
      ),
    );
  }

  static BoxDecoration navBar({required bool isDark}) {
    return BoxDecoration(
      color: isDark
          ? const Color(0xFF141829).withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.85),
      border: Border(
        top: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 30,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }
}


class SkyCastTheme {
  static TextTheme _buildTextTheme(bool isDark) {
    final baseColor = isDark ? SkyCastColors.darkOnSurface : SkyCastColors.lightOnSurface;
    final dimColor = isDark ? SkyCastColors.darkOnSurfaceVariant : SkyCastColors.lightOnSurfaceVariant;

    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 96,
        fontWeight: FontWeight.w700,
        letterSpacing: -3.84,
        color: baseColor,
        height: 1.04,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 60,
        fontWeight: FontWeight.w700,
        letterSpacing: -2.4,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: dimColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: dimColor,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: baseColor,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: dimColor,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.55,
        color: dimColor,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SkyCastColors.darkSurface,
      textTheme: _buildTextTheme(true),
      colorScheme: const ColorScheme.dark(
        surface: SkyCastColors.darkSurface,
        primary: SkyCastColors.primary,
        secondary: SkyCastColors.secondary,
        tertiary: SkyCastColors.tertiary,
        onSurface: SkyCastColors.darkOnSurface,
        onSurfaceVariant: SkyCastColors.darkOnSurfaceVariant,
        outline: SkyCastColors.darkOutline,
        surfaceContainerHighest: SkyCastColors.darkSurfaceContainerHighest,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: SkyCastColors.darkOnSurface,
        ),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: SkyCastColors.lightSurface,
      textTheme: _buildTextTheme(false),
      colorScheme: const ColorScheme.light(
        surface: SkyCastColors.lightSurface,
        primary: SkyCastColors.primary,
        secondary: SkyCastColors.secondary,
        tertiary: SkyCastColors.tertiary,
        onSurface: SkyCastColors.lightOnSurface,
        onSurfaceVariant: SkyCastColors.lightOnSurfaceVariant,
        outline: SkyCastColors.lightOutline,
        surfaceContainerHighest: SkyCastColors.lightSurfaceContainerHighest,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: SkyCastColors.lightOnSurface,
        ),
      ),
    );
  }
}
