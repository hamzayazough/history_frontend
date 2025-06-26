import 'package:flutter/material.dart';
import '../../../../core/constants/histofacts_colors.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onProfileTap;

  const HeaderBar({
    super.key,
    this.onDiscoverTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HistofactsColors.purpleGradient[0].withOpacity(0.9),
              HistofactsColors.purpleGradient[0].withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Navigate to home or refresh
            },
            child: const Text(
              'Histofacts',
              style: TextStyle(
                color: HistofactsColors.lightText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onDiscoverTap,
            icon: const Icon(
              Icons.explore,
              color: HistofactsColors.lightText,
              size: 24,
            ),
            tooltip: 'Discover',
          ),
        ],
      ),
      leadingWidth: 180,
      actions: [
        IconButton(
          onPressed: onProfileTap,
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  HistofactsColors.purpleGradient[4],
                  HistofactsColors.purpleGradient[6],
                ],
              ),
              border: Border.all(
                color: HistofactsColors.lightText,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: HistofactsColors.lightText,
              size: 18,
            ),
          ),
          tooltip: 'Profile',
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
