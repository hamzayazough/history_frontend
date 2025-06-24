import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class CreateFigureView extends ConsumerStatefulWidget {
  const CreateFigureView({super.key});

  @override
  ConsumerState<CreateFigureView> createState() => _CreateFigureViewState();
}

class _CreateFigureViewState extends ConsumerState<CreateFigureView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Figure'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 64,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16),
            Text(
              'Create Figure',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
