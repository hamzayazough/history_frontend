import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_timeline/core/theme/theme_data.dart';
import 'package:history_timeline/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: HistoryTimelineApp()));
}

class HistoryTimelineApp extends StatelessWidget {
  const HistoryTimelineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'History Timeline',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
