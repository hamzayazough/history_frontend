import 'package:flutter/material.dart';
import 'package:history_timeline/core/models/country_data.dart';
import 'package:history_timeline/core/constants/app_countries.dart';
import 'dart:math' as math;

class EarthGlobeWidget extends StatefulWidget {
  final Function(CountryData) onCountryTap;

  const EarthGlobeWidget({
    super.key,
    required this.onCountryTap,
  });

  @override
  State<EarthGlobeWidget> createState() => _EarthGlobeWidgetState();
}

class _EarthGlobeWidgetState extends State<EarthGlobeWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    // Start auto-rotation
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          children: [
            // Stars background
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF1a1a2e),
                    Color(0xFF16213e),
                    Color(0xFF0f0f23),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: StarsPainter(),
                child: Container(),
              ),
            ), // Earth Globe - Simple 3D Globe Alternative
            Center(
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF4A90E2),
                          Color(0xFF2E5BDA),
                          Color(0xFF1E3A8A),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Globe texture simulation
                        CustomPaint(
                          painter: GlobePainter(_rotationController.value),
                          size: const Size(300, 300),
                        ),
                        // Interactive overlay
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Simulate a country tap - for demo purposes
                              final countries = AppCountries.allCountries;
                              if (countries.isNotEmpty) {
                                widget.onCountryTap(countries.first);
                              }
                            },
                            borderRadius: BorderRadius.circular(150),
                            child: Container(
                              width: 300,
                              height: 300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Overlay with interaction hint
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Interactive Earth Globe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Click countries below to explore',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGlobeTap(double latitude, double longitude) {
    // Find the closest country based on coordinates
    final country = _findCountryByCoordinates(latitude, longitude);
    if (country != null) {
      widget.onCountryTap(country);
    }
  }

  CountryData? _findCountryByCoordinates(double latitude, double longitude) {
    // Simple implementation - in a real app, you'd have more precise country boundaries
    for (final country in AppCountries.allCountries) {
      // This is a simplified approach - you'd need actual country boundary data
      if ((latitude - country.latitude).abs() < 10 &&
          (longitude - country.longitude).abs() < 10) {
        return country;
      }
    }
    return null;
  }
}

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw random stars
    for (int i = 0; i < 100; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 73) % size.height;
      final radius = (i % 3 + 1).toDouble();
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GlobePainter extends CustomPainter {
  final double animationValue;

  GlobePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw continents as simple shapes that rotate
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60.0 + animationValue * 360) * (3.14159 / 180);
      final x = center.dx + (radius * 0.6) * math.cos(angle);
      final y = center.dy + (radius * 0.6) * math.sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        radius * 0.2,
        paint,
      );
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Latitude lines
    for (int i = 1; i < 5; i++) {
      final lineRadius = radius * i / 5;
      canvas.drawCircle(center, lineRadius, gridPaint);
    }

    // Longitude lines
    for (int i = 0; i < 8; i++) {
      final angle = i * 45.0 * (3.14159 / 180);
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
