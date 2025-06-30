import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:history_timeline/core/models/country_data.dart';
import 'package:history_timeline/core/constants/app_countries.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
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
  late FlutterEarthGlobeController _controller;
  late AnimationController _rotationController;
  late AnimationController _zoomController;

  double _currentZoom = 1.0;
  double _targetZoom = 1.0;
  static const double _minZoom = 0.5;
  static const double _maxZoom = 3.0;

  Offset? _lastPanPosition;
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  bool _isUserInteracting = false;
  DateTime? _lastInteractionTime;

  @override
  void initState() {
    super.initState();

    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      isBackgroundFollowingSphereRotation: true,
      // background: Image.asset('assets/images/stars_background.jpg').image,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Start auto-rotation
    _startAutoRotation();
  }

  void _startAutoRotation() {
    if (!_isUserInteracting) {
      _rotationController.repeat();
    }
  }

  void _stopAutoRotation() {
    _rotationController.stop();
    _isUserInteracting = true;
    _lastInteractionTime = DateTime.now();

    // Resume auto-rotation after 3 seconds of inactivity
    Future.delayed(const Duration(seconds: 3), () {
      if (_lastInteractionTime != null &&
          DateTime.now().difference(_lastInteractionTime!) >=
              const Duration(seconds: 3)) {
        setState(() {
          _isUserInteracting = false;
        });
        _startAutoRotation();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _stopAutoRotation();
    _lastPanPosition = details.focalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    _stopAutoRotation();

    // Handle rotation (panning)
    if (_lastPanPosition != null) {
      final delta = details.focalPoint - _lastPanPosition!;
      setState(() {
        _rotationX += delta.dy * 0.01;
        _rotationY += delta.dx * 0.01;

        // Limit vertical rotation to prevent flipping
        _rotationX = _rotationX.clamp(-1.5, 1.5);
      });
      _lastPanPosition = details.focalPoint;
    }

    // Handle zoom (scaling)
    if (details.scale != 1.0) {
      setState(() {
        _targetZoom = (_currentZoom * details.scale).clamp(_minZoom, _maxZoom);
      });

      _zoomController.forward(from: 0).then((_) {
        _currentZoom = _targetZoom;
      });
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _lastPanPosition = null;
  }

  void _handleTap(TapDownDetails details, Size size) {
    // Convert tap position to sphere coordinates
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Calculate normalized coordinates (-1 to 1)
    final x = (localPosition.dx / size.width) * 2 - 1;
    final y = (localPosition.dy / size.height) * 2 - 1;

    // Check if tap is within sphere bounds
    if (x * x + y * y <= 1) {
      // Calculate approximate lat/long from tap position
      final lat = math.asin(y) * 180 / math.pi;
      final lon = math.atan2(x, math.sqrt(1 - x * x - y * y)) * 180 / math.pi;

      // Find nearest country
      final country = _findNearestCountry(lat, lon);
      if (country != null) {
        widget.onCountryTap(country);
      }
    }
  }

  CountryData? _findNearestCountry(double lat, double lon) {
    CountryData? nearestCountry;
    double minDistance = double.infinity;

    for (final country in AppCountries.allCountries) {
      final distance =
          _calculateDistance(lat, lon, country.latitude, country.longitude);

      if (distance < minDistance && distance < 15) {
        // 15 degree threshold
        minDistance = distance;
        nearestCountry = country;
      }
    }

    return nearestCountry;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final dLat = (lat2 - lat1).abs();
    final dLon = (lon2 - lon1).abs();
    return math.sqrt(dLat * dLat + dLon * dLon);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          math.min(constraints.maxWidth, 400),
          math.min(constraints.maxHeight, 400),
        );

        return Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 50,
                spreadRadius: -20,
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
                        Color(0xFF0a0e27),
                        Color(0xFF020617),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: EnhancedStarsPainter(),
                    size: size,
                  ),
                ),

                // 3D Earth Globe
                GestureDetector(
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onScaleEnd: _handleScaleEnd,
                  onTapDown: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationController,
                      _zoomController,
                    ]),
                    builder: (context, child) {
                      final rotation = _isUserInteracting
                          ? 0.0
                          : _rotationController.value * 2 * math.pi;

                      final zoom = _currentZoom +
                          (_targetZoom - _currentZoom) * _zoomController.value;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..scale(zoom)
                          ..rotateX(_rotationX)
                          ..rotateY(_rotationY + rotation),
                        child: Container(
                          width: size.width,
                          height: size.height,
                          child: CustomPaint(
                            painter: RealisticEarthPainter(
                              rotation: rotation,
                              zoom: zoom,
                            ),
                            size: size,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Atmosphere glow effect
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          Colors.blue.withOpacity(0.1),
                          Colors.blue.withOpacity(0.2),
                        ],
                        stops: const [0.7, 0.9, 1.0],
                      ),
                    ),
                  ),
                ),

                // Highlight effect on top
                Positioned(
                  top: size.height * 0.1,
                  left: size.width * 0.3,
                  child: Container(
                    width: size.width * 0.2,
                    height: size.height * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EnhancedStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create different star sizes and brightnesses
    final random = math.Random(42); // Fixed seed for consistent stars

    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final brightness = random.nextDouble();
      final radius = random.nextDouble() * 2 + 0.5;

      // Vary star colors slightly
      if (brightness > 0.9) {
        paint.color = Colors.white;
      } else if (brightness > 0.7) {
        paint.color = Colors.blue[100]!.withOpacity(brightness);
      } else {
        paint.color = Colors.white.withOpacity(brightness * 0.8);
      }

      canvas.drawCircle(Offset(x, y), radius, paint);

      // Add glow effect for brighter stars
      if (brightness > 0.8) {
        paint.color = paint.color.withOpacity(0.3);
        canvas.drawCircle(Offset(x, y), radius * 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RealisticEarthPainter extends CustomPainter {
  final double rotation;
  final double zoom;

  RealisticEarthPainter({
    required this.rotation,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.9;

    // Draw Earth sphere with gradient
    final earthPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          const Color(0xFF4A90E2),
          const Color(0xFF2E5BDA),
          const Color(0xFF1E3A8A),
          const Color(0xFF0F1F4A),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, earthPaint);

    // Draw continents
    _drawContinents(canvas, center, radius);

    // Draw cloud layer
    _drawClouds(canvas, center, radius);

    // Draw grid lines for better 3D effect
    _drawGridLines(canvas, center, radius);

    // Draw shadow for 3D effect
    _drawShadow(canvas, center, radius);
  }

  void _drawContinents(Canvas canvas, Offset center, double radius) {
    final continentPaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.fill;

    // Simplified continent shapes based on rotation
    final continents = [
      // Africa and Europe
      _ContinentData(
        centerLat: 0,
        centerLon: 20,
        points: [
          Offset(-20, -35),
          Offset(0, -35),
          Offset(20, -30),
          Offset(30, -10),
          Offset(35, 10),
          Offset(30, 30),
          Offset(20, 35),
          Offset(0, 30),
          Offset(-10, 20),
          Offset(-20, 0),
          Offset(-20, -20),
        ],
      ),
      // Americas
      _ContinentData(
        centerLat: 0,
        centerLon: -90,
        points: [
          Offset(-20, -50),
          Offset(-10, -45),
          Offset(0, -30),
          Offset(10, -10),
          Offset(15, 10),
          Offset(10, 30),
          Offset(0, 45),
          Offset(-10, 50),
          Offset(-20, 40),
          Offset(-25, 20),
          Offset(-30, 0),
          Offset(-25, -20),
        ],
      ),
      // Asia
      _ContinentData(
        centerLat: 30,
        centerLon: 90,
        points: [
          Offset(-30, -20),
          Offset(0, -25),
          Offset(30, -20),
          Offset(50, -10),
          Offset(60, 10),
          Offset(50, 20),
          Offset(30, 25),
          Offset(0, 20),
          Offset(-20, 15),
        ],
      ),
    ];

    for (final continent in continents) {
      _drawContinent(canvas, center, radius, continent, continentPaint);
    }
  }

  void _drawContinent(Canvas canvas, Offset center, double radius,
      _ContinentData continent, Paint paint) {
    final adjustedLon = continent.centerLon + rotation * 180 / math.pi;

    // Check if continent is visible
    if (adjustedLon > -90 && adjustedLon < 90) {
      final path = Path();
      bool first = true;

      for (final point in continent.points) {
        final lat = continent.centerLat + point.dy;
        final lon = adjustedLon + point.dx;

        final pos = _latLonToXY(lat, lon, center, radius);

        if (first) {
          path.moveTo(pos.dx, pos.dy);
          first = false;
        } else {
          path.lineTo(pos.dx, pos.dy);
        }
      }

      path.close();

      // Add gradient for realistic look
      paint.shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        colors: [
          const Color(0xFFB8956A),
          const Color(0xFF8B7355),
          const Color(0xFF5D4E37),
        ],
      ).createShader(path.getBounds());

      canvas.drawPath(path, paint);
    }
  }

  void _drawClouds(Canvas canvas, Offset center, double radius) {
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Draw some cloud patches
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72 + rotation * 30) * math.pi / 180;
      final cloudRadius = radius * 0.15;
      final distance = radius * 0.7;

      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle) * 0.5;

      if (math.cos(angle) > 0) {
        // Only show clouds on visible side
        canvas.drawCircle(Offset(x, y), cloudRadius, cloudPaint);
      }
    }
  }

  void _drawGridLines(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Latitude lines
    for (int lat = -60; lat <= 60; lat += 30) {
      final path = Path();
      bool first = true;

      for (int lon = -180; lon <= 180; lon += 10) {
        final adjustedLon = lon + rotation * 180 / math.pi;
        if (adjustedLon > -90 && adjustedLon < 90) {
          final pos = _latLonToXY(lat.toDouble(), adjustedLon, center, radius);

          if (first) {
            path.moveTo(pos.dx, pos.dy);
            first = false;
          } else {
            path.lineTo(pos.dx, pos.dy);
          }
        }
      }

      canvas.drawPath(path, gridPaint);
    }

    // Longitude lines
    for (int lon = 0; lon < 360; lon += 30) {
      final adjustedLon = lon + rotation * 180 / math.pi;
      if (adjustedLon > -90 && adjustedLon < 90) {
        final path = Path();
        bool first = true;

        for (int lat = -90; lat <= 90; lat += 10) {
          final pos = _latLonToXY(lat.toDouble(), adjustedLon, center, radius);

          if (first) {
            path.moveTo(pos.dx, pos.dy);
            first = false;
          } else {
            path.lineTo(pos.dx, pos.dy);
          }
        }

        canvas.drawPath(path, gridPaint);
      }
    }
  }

  void _drawShadow(Canvas canvas, Offset center, double radius) {
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.3),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final shadowPath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi / 2,
        math.pi,
      );

    canvas.drawPath(shadowPath, shadowPaint);
  }

  Offset _latLonToXY(double lat, double lon, Offset center, double radius) {
    // Convert lat/lon to radians
    final latRad = lat * math.pi / 180;
    final lonRad = lon * math.pi / 180;

    // 3D to 2D projection
    final x = radius * math.sin(lonRad) * math.cos(latRad);
    final y = radius * math.sin(latRad);
    final z = radius * math.cos(lonRad) * math.cos(latRad);

    // Only draw if on visible hemisphere
    if (z > 0) {
      return Offset(
        center.dx + x,
        center.dy - y,
      );
    }

    return center;
  }

  @override
  bool shouldRepaint(RealisticEarthPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.zoom != zoom;
}

class _ContinentData {
  final double centerLat;
  final double centerLon;
  final List<Offset> points;

  _ContinentData({
    required this.centerLat,
    required this.centerLon,
    required this.points,
  });
}
