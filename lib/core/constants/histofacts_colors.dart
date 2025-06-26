import 'package:flutter/material.dart';

/// Histofacts color palette - Purple gradient colors
class HistofactsColors {
  static const List<Color> purpleGradient = [
    Color(0xFF10005A), // Deepest purple
    Color(0xFF21007D),
    Color(0xFF3A00B0),
    Color(0xFF5300D9),
    Color(0xFF7600FF),
    Color(0xFF943CFF),
    Color(0xFFA96EFF),
  ];

  /// Primary gradient for backgrounds
  static const LinearGradient mainBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF10005A), // Deep purple
      Color(0xFF3A00B0), // Medium purple
      Color(0xFF7600FF), // Bright purple
    ],
  );

  /// Light text color for contrast on dark backgrounds
  static const Color lightText = Color(0xFFF8F4FF);

  /// Semi-transparent overlay
  static const Color overlay = Color(0x80000000);

  /// Globe highlight color
  static const Color globeHighlight = Color(0xFF943CFF);

  /// Tip box background
  static const Color tipBoxBackground = Color(0x90FFFFFF);
}
