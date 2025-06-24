// Core Constants
class AppConstants {
  static const String appName = 'Historical Timeline';
  static const String appVersion = '1.0.0';

  // GraphQL
  static const String graphqlEndpoint = 'http://localhost:3000/graphql';

  // Pagination
  static const int defaultPageSize = 20;
  static const int discoverPageSize = 10;

  // Image
  static const int maxImageSizeMB = 5;
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp'
  ];

  // Validation
  static const int maxCommentLength = 500;
  static const int maxDescriptionLength = 2000;
}

// Storage Keys
class StorageKeys {
  static const String userToken = 'user_token';
  static const String userData = 'user_data';
  static const String onboardingComplete = 'onboarding_complete';
}

// Route Names
class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String regionTimeline = '/region';
  static const String eventDetail = '/event';
  static const String figureDetail = '/figure';
  static const String createEvent = '/create-event';
  static const String createFigure = '/create-figure';
  static const String discover = '/discover';
  static const String adminPanel = '/admin';
  static const String profile = '/profile';
}

// Entity Types
enum EntityType {
  EVENT,
  FIGURE,
  USER,
}

// Report Reasons
enum ReportReason {
  INAPPROPRIATE_CONTENT,
  SPAM,
  HARASSMENT,
  FALSE_INFORMATION,
  COPYRIGHT_VIOLATION,
  OTHER,
}

// Discover Types
enum DiscoverType {
  EVENT,
  FIGURE,
}
