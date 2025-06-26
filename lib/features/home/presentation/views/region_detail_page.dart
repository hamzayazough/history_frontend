import 'package:flutter/material.dart';
import '../../../../core/models/region.dart';
import '../../../../core/constants/histofacts_colors.dart';

class RegionDetailPage extends StatelessWidget {
  final Region region;

  const RegionDetailPage({
    super.key,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: HistofactsColors.lightText,
          ),
        ),
        title: Text(
          region.displayName,
          style: const TextStyle(
            color: HistofactsColors.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: HistofactsColors.mainBackground,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Region title
                Text(
                  region.displayName,
                  style: const TextStyle(
                    color: HistofactsColors.lightText,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                // Event count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: HistofactsColors.purpleGradient[4].withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: HistofactsColors.purpleGradient[4],
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${region.eventCount} Historical Events',
                    style: TextStyle(
                      color: HistofactsColors.purpleGradient[6],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  region.description,
                  style: TextStyle(
                    color: HistofactsColors.lightText.withOpacity(0.9),
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to timeline
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Opening ${region.displayName} timeline...'),
                              backgroundColor:
                                  HistofactsColors.purpleGradient[4],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HistofactsColors.purpleGradient[4],
                          foregroundColor: HistofactsColors.lightText,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Explore Timeline',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to events list
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Opening ${region.displayName} events...'),
                              backgroundColor:
                                  HistofactsColors.purpleGradient[2],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: HistofactsColors.lightText,
                          side: const BorderSide(
                            color: HistofactsColors.lightText,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View Events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
