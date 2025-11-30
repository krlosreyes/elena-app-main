import 'package:flutter/material.dart';

class ElenaColors {
  static const primary = Color(0xFF21808D);
  static const secondary = Color(0xFF5E5240);
  static const background = Color(0xFFFCFCF9);
  static const surface = Colors.white;
  static const Color cardBackground = Color(0xFFF7F7F7);

  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.black54;
  static const textHint = Colors.black45;

  static const border = Color(0xFFE6E6E0);

  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA726);
  static const error = Color(0xFFC0152F);
  static const info = Color(0xFF29B6F6);

  static const xp = Color(0xFFFFD700);
  static const streak = Color(0xFFFF5722);

  static const xpGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static Color? get textDark => null;
}
