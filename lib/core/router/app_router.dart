import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:history_timeline/core/constants/app_constants.dart';
import 'package:history_timeline/features/auth/presentation/auth_view.dart';
import 'package:history_timeline/features/home/presentation/home_view.dart';
import 'package:history_timeline/features/timeline/presentation/region_timeline_view.dart';
import 'package:history_timeline/features/events/presentation/event_detail_view.dart';
import 'package:history_timeline/features/figures/presentation/figure_detail_view.dart';
import 'package:history_timeline/features/events/presentation/create_event_view.dart';
import 'package:history_timeline/features/figures/presentation/create_figure_view.dart';
import 'package:history_timeline/features/discover/presentation/discover_view.dart';
import 'package:history_timeline/features/admin/presentation/admin_panel_view.dart';
import 'package:history_timeline/features/profile/presentation/profile_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Splash/Login
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const AuthView(),
      ),

      // Main Navigation
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),

      // Timeline
      GoRoute(
        path: '${RouteNames.regionTimeline}/:regionId',
        name: 'regionTimeline',
        builder: (context, state) {
          final regionId = state.pathParameters['regionId']!;
          return RegionTimelineView(regionId: regionId);
        },
      ),

      // Event Details
      GoRoute(
        path: '${RouteNames.eventDetail}/:eventId',
        name: 'eventDetail',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return EventDetailView(eventId: eventId);
        },
      ),

      // Figure Details
      GoRoute(
        path: '${RouteNames.figureDetail}/:figureId',
        name: 'figureDetail',
        builder: (context, state) {
          final figureId = state.pathParameters['figureId']!;
          return FigureDetailView(figureId: figureId);
        },
      ),

      // Create Content
      GoRoute(
        path: RouteNames.createEvent,
        name: 'createEvent',
        builder: (context, state) {
          final regionId = state.uri.queryParameters['regionId'];
          return CreateEventView(regionId: regionId);
        },
      ),
      GoRoute(
        path: RouteNames.createFigure,
        name: 'createFigure',
        builder: (context, state) => const CreateFigureView(),
      ),

      // Discover
      GoRoute(
        path: RouteNames.discover,
        name: 'discover',
        builder: (context, state) => const DiscoverView(),
      ),

      // Admin Panel
      GoRoute(
        path: RouteNames.adminPanel,
        name: 'adminPanel',
        builder: (context, state) => const AdminPanelView(),
      ),

      // Profile
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
}
