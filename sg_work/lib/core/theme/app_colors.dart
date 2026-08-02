import 'package:flutter/material.dart';

/// Modern, premium color system for SewaGhar
/// Inspired by Material 3, Airbnb, and Stripe design languages
class AppColors {
  // ─── Primary Palette ───
  static const Color primary = Color(0xFF4F46E5); // Indigo-600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo-400
  static const Color primaryDark = Color(0xFF3730A3); // Indigo-800
  static const Color primaryContainer = Color(0xFFEEF2FF); // Indigo-50

  // ─── Secondary Palette ───
  static const Color secondary = Color(0xFF0EA5E9); // Sky-500
  static const Color secondaryLight = Color(0xFF7DD3FC); // Sky-300
  static const Color secondaryContainer = Color(0xFFF0F9FF); // Sky-50

  // ─── Accent ───
  static const Color accent = Color(0xFF06B6D4); // Cyan-500
  static const Color accentLight = Color(0xFF67E8F9); // Cyan-300

  // ─── Neutral / Surface ───
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate-100
  static const Color outline = Color(0xFFE2E8F0); // Slate-200
  static const Color outlineVariant = Color(0xFFCBD5E1); // Slate-300

  // ─── Text ───
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textTertiary = Color(0xFF94A3B8); // Slate-400
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF1F5F9);

  // ─── Semantic ───
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color successContainer = Color(0xFFD1FAE5); // Emerald-100
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningContainer = Color(0xFFFEF3C7); // Amber-100
  static const Color danger = Color(0xFFEF4444); // Red-500
  static const Color dangerContainer = Color(0xFFFEE2E2); // Red-100
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoContainer = Color(0xFFDBEAFE); // Blue-100

  // ─── Rating ───
  static const Color starActive = Color(0xFFF59E0B);
  static const Color starInactive = Color(0xFFD1D5DB);

  // ─── Professional Status ───
  static const Color verified = Color(0xFF10B981);
  static const Color pending = Color(0xFFF59E0B);
  static const Color featured = Color(0xFF8B5CF6); // Violet-500

  // ─── Booking Status ───
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusAccepted = Color(0xFF3B82F6);
  static const Color statusOngoing = Color(0xFF8B5CF6);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFFEF4444);

  // ─── Shadows ───
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];
  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}

