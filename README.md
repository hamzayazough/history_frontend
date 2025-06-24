# Historical Timeline Flutter App

A Flutter application for exploring historical timelines across different regions of the world.

## Features

- 🔐 **Firebase Authentication** - Anonymous and email-based login
- 🗺️ **Interactive Map** - Select regions to explore their history
- 📅 **Timeline Views** - Browse historical events and figures chronologically
- 👤 **User-Generated Content** - Create and share historical events and figures
- 💬 **Comments & Reactions** - Like, dislike, and comment on content
- 🚨 **Reporting System** - Report inappropriate content
- 📱 **Modern UI** - Clean, responsive Material Design 3 interface

## Architecture

This project follows **Clean Architecture** principles with a feature-based folder structure:

```
lib/
  core/                    # Shared utilities and configurations
    constants/             # App constants and enums
    graphql/              # GraphQL queries, mutations, and service
    router/               # App routing configuration
    theme/                # UI theme and styling
  features/               # Feature modules
    auth/                 # Authentication
    home/                 # Home screen with region selection
    timeline/             # Region timeline views
    events/               # Event detail and creation
    figures/              # Figure detail and creation
    discover/             # Discovery feed (TikTok-style)
    admin/                # Admin panel for content management
    profile/              # User profile and settings
```

## Tech Stack

- **Framework**: Flutter 3.24+
- **State Management**: Riverpod
- **Routing**: go_router
- **Authentication**: Firebase Auth
- **Backend**: GraphQL API (NestJS + PostgreSQL)
- **UI**: Material Design 3 + Custom Theme
- **Styling**: flutter_screenutil for responsive design
- **Image Handling**: cached_network_image
- **Code Generation**: freezed + json_annotation

## Getting Started

### Prerequisites

- Flutter 3.24+ installed
- Firebase project configured
- Backend GraphQL server running

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Update `lib/firebase_options.dart` with your Firebase configuration
4. Update GraphQL endpoint:
   - Modify `AppConstants.graphqlEndpoint` in `lib/core/constants/app_constants.dart`
5. Run the app:
   ```bash
   flutter run
   ```

## Development Status

This is the initial scaffolding of the Flutter application. The project includes:

✅ **Completed:**

- Project structure and architecture setup
- Core theme and styling system
- Firebase authentication integration
- Basic navigation and routing
- Login/authentication screens
- Home screen with region selection
- Timeline view for regions
- Event and figure detail pages
- Create event functionality
- Profile management
- Admin panel structure

🚧 **In Progress:**

- GraphQL integration (service setup complete, needs backend connection)
- Data models with code generation
- State management with Riverpod providers

📋 **Planned:**

- Complete create figure functionality
- Discover feed implementation
- Advanced admin features
- Image upload integration
- Comment system implementation
- Like/dislike functionality
- Reporting system
- Interactive map integration
- Performance optimizations

## Running the Project

The project is ready to run with mock data:

```bash
flutter pub get
flutter run
```

Note: GraphQL integration is temporarily disabled until backend is connected.
