import 'dart:math';
import 'package:flutter/material.dart';
import 'package:history_timeline/core/constants/app_countries.dart';
import 'package:history_timeline/core/models/country_data.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class EarthGlobeWidget extends StatefulWidget {
  final Function(CountryData country)? onCountryTap;
  final double radius;

  const EarthGlobeWidget({
    super.key,
    this.onCountryTap,
    this.radius = 200,
  });

  @override
  State<EarthGlobeWidget> createState() => _EarthGlobeWidgetState();
}

class _EarthGlobeWidgetState extends State<EarthGlobeWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  String? _selectedContinent;
  List<CountryData> _filteredCountries = AppCountries.allCountries;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  Color _getColorByContinent(String continent) {
    switch (continent) {
      case 'Africa':
        return Colors.orange;
      case 'Asia':
        return Colors.red;
      case 'Europe':
        return Colors.blue;
      case 'North America':
        return Colors.green;
      case 'South America':
        return Colors.purple;
      case 'Oceania':
        return Colors.cyan;
      default:
        return AppColors.primary;
    }
  }

  void _onCountryTap(CountryData country) {
    _showCountryDialog(country);
    widget.onCountryTap?.call(country);
  }

  void _showCountryDialog(CountryData country) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _getColorByContinent(country.continent),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(country.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Continent: ${country.continent}'),
            Text('Code: ${country.code}'),
            Text(
                'Coordinates: ${country.latitude.toStringAsFixed(2)}, ${country.longitude.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(
              'Explore historical events and figures from ${country.name}.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to country timeline
              // context.go('${RouteNames.countryTimeline}/${country.id}');
            },
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }

  void _filterByContinent(String? continent) {
    setState(() {
      _selectedContinent = continent;
      if (continent == null) {
        _filteredCountries = AppCountries.allCountries;
      } else {
        _filteredCountries = AppCountries.getByContinent(continent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Globe visualization (placeholder with beautiful UI)
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              gradient: RadialGradient(
                colors: [
                  Colors.blue.shade900,
                  Colors.black,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              child: Stack(
                children: [
                  // Animated background stars
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * 3.14159,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.indigo.shade900,
                                Colors.black,
                              ],
                            ),
                          ),
                          child: CustomPaint(
                            painter: StarsPainter(),
                            size: Size.infinite,
                          ),
                        ),
                      );
                    },
                  ),
                  // Central Earth representation
                  Center(
                    child: Container(
                      width: widget.radius,
                      height: widget.radius,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade700,
                            Colors.blue.shade900,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.public,
                        size: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  // Overlay text
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Interactive Earth Globe\nClick countries below to explore',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),

        // Continent filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ContinentChip(
                label: 'All',
                isSelected: _selectedContinent == null,
                onTap: () => _filterByContinent(null),
              ),
              ...AppCountries.getAllContinents().map(
                (continent) => _ContinentChip(
                  label: continent,
                  color: _getColorByContinent(continent),
                  isSelected: _selectedContinent == continent,
                  onTap: () => _filterByContinent(continent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),

        // Countries grid
        Expanded(
          flex: 2,
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _filteredCountries.length,
            itemBuilder: (context, index) {
              final country = _filteredCountries[index];
              return _CountryTile(
                country: country,
                color: _getColorByContinent(country.continent),
                onTap: () => _onCountryTap(country),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }
}

class _ContinentChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContinentChip({
    required this.label,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? (color ?? AppColors.primary) : AppColors.grey100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? (color ?? AppColors.primary) : AppColors.grey200,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.grey700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  final CountryData country;
  final Color color;
  final VoidCallback onTap;

  const _CountryTile({
    required this.country,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey200.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  country.name,
                  style: AppTextStyles.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryInfoWidget extends StatelessWidget {
  final CountryData country;
  final VoidCallback? onExplore;

  const CountryInfoWidget({
    super.key,
    required this.country,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _getColorByContinent(country.continent),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              Expanded(
                child: Text(
                  country.name,
                  style: AppTextStyles.h4,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            country.continent,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          if (onExplore != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onExplore,
                child: const Text('Explore History'),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorByContinent(String continent) {
    switch (continent) {
      case 'Africa':
        return Colors.orange;
      case 'Asia':
        return Colors.red;
      case 'Europe':
        return Colors.blue;
      case 'North America':
        return Colors.green;
      case 'South America':
        return Colors.purple;
      case 'Oceania':
        return Colors.cyan;
      default:
        return AppColors.primary;
    }
  }
}

class StarsPainter extends CustomPainter {
  final Random _random = Random(42); // Fixed seed for consistent stars

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw stars
    for (int i = 0; i < 50; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 2 + 0.5;

      paint.color = Colors.white.withOpacity(_random.nextDouble() * 0.8 + 0.2);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
