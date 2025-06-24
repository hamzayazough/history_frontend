import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:history_timeline/core/constants/app_constants.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;

  // Mock regions data - will be replaced with GraphQL data
  final List<RegionData> _regions = [
    RegionData(id: '1', name: 'Europe', lat: 54.5260, lng: 15.2551),
    RegionData(id: '2', name: 'Asia', lat: 34.0479, lng: 100.6197),
    RegionData(id: '3', name: 'Africa', lat: -8.7832, lng: 34.5085),
    RegionData(id: '4', name: 'North America', lat: 54.5260, lng: -105.2551),
    RegionData(id: '5', name: 'South America', lat: -8.7832, lng: -55.4915),
    RegionData(id: '6', name: 'Oceania', lat: -25.2744, lng: 133.7751),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        context.go(RouteNames.login);
      }
    });
  }

  void _onRegionTap(RegionData region) {
    context.go('${RouteNames.regionTimeline}/${region.id}');
  }

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        context.go(RouteNames.discover);
        break;
      case 2:
        context.go(RouteNames.adminPanel);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Timeline'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Text(
              'Explore History',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              'Select a region to discover historical events and figures',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing32),

            // Map placeholder (will be replaced with actual map)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public,
                        size: 64,
                        color: AppColors.grey400,
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      Text(
                        'Interactive World Map',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        'Coming Soon',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),

            // Region List (temporary until map is implemented)
            Text(
              'Available Regions',
              style: AppTextStyles.h4,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _regions.length,
                itemBuilder: (context, index) {
                  final region = _regions[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: AppDimensions.spacing12),
                    child: _RegionCard(
                      region: region,
                      onTap: () => _onRegionTap(region),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _RegionCard extends StatelessWidget {
  final RegionData region;
  final VoidCallback onTap;

  const _RegionCard({
    required this.region,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey200.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              region.name,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class RegionData {
  final String id;
  final String name;
  final double lat;
  final double lng;

  RegionData({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });
}
