# 🏢 Enterprise Flutter Guidelines

---

## 🎯 Architecture & Folder Structure

- **Follow Clean Architecture:**  
  Split code into these layers:

  - `presentation`
  - `domain`
  - `data`
  - `core`

- **Feature-First Structure:**

  ```
  lib/
    core/         # Shared utils, constants, themes
    features/
      <feature>/
        presentation/   # Views, viewmodels (e.g., riverpod, bloc providers)
        domain/         # Entities, usecases, abstract repositories
        data/           # Repo implementations, services, mappers
    main.dart
  ```

- **Separation of Concerns:**  
  UI ← ViewModels ← UseCases ← Repositories ← Services

---

## 🧩 Naming Conventions

- **Folders & files:** `snake_case.dart`
- **Classes/widgets:** `PascalCase`
- **Methods/variables:** `camelCase`
- **Constants:** `SCREAMING_SNAKE_CASE`
- **Suffixes:**
  - `_view.dart`
  - `_view_model.dart`
  - `_use_case.dart`
  - `_repository.dart`
  - `_service.dart`
  - `_mapper.dart`

---

## 🔌 State Management & Dependency Injection

- Use **Riverpod**, **flutter_bloc**, or **StateNotifier** for state management.
- Define DI in `core/di.dart` using `get_it` or `injectable`.
- Initialize DI in `main.dart`.
- Register feature providers/blocs scoped within features.

---

## 🌐 Networking & Data

- Use `dio` (with interceptors) or `http` for API calls.
- Use `json_serializable` + `freezed` for JSON parsing, immutability, and unions.
- Place mappers in `data/mappers/`.

---

## 🎨 UI & Widget Practices

- Prefer `StatelessWidget` and `const` constructors by default.
- Decompose UI into small, reusable widgets.
- Use `ValueKey`/`UniqueKey` in lists.
- Maintain consistent formatting with trailing commas for readability.
- Avoid heavy widget rebuilds; design efficiently.

---

## 📦 Core & Reusable Components

- `core/` should include:
  - `constants/`
  - `themes/`
  - `utils/`
  - `extensions/`
  - `core_widgets/`
- Place shared styles, validators, error types, and date-helpers here.

---

## 🛠 Styling & Quality

- Follow official Dart style:
  - Single quotes
  - Trailing commas
  - Arrow functions
- Configure `analysis_options.yaml`:
  ```yaml
  include: package:flutter_lints/flutter.yaml
  linter:
    rules:
      prefer_const_constructors: true
      avoid_print: true
  ```
- Run `dart format`, remove unused imports, and ensure no commented-out code.

---

## ⚡ Performance Optimizations

- Use `cached_network_image` for image caching.
- Load lists lazily via `ListView.builder`.
- Minimize `setState`; rely on state management.
- Use `const` where possible to reduce rebuild cost.

---

## 🛡 Security & Compliance

- Use `flutter_secure_storage` for sensitive data.
- Enforce HTTPS-only communication with proper certificate handling.
- Keep native integration clear and minimal using platform channels when necessary.

---

## 📚 References

- [hypersense-software.com](https://hypersense-software.com)
- [tothenew.com](https://tothenew.com)
- [miquido.com](https://miquido.com)

---

## ❗️ Non-negotiable

All Copilot edits—scaffolded features, refactors, PRs—**must strictly follow these guidelines** in naming, structure, libraries, and
