# Attendency Mobile App

A Flutter-based mobile application for attendance management using OCR (Optical Character Recognition) for ID card scanning and proximity-based session discovery for check-in/check-out.

## 📱 Overview

**Attendency** is an attendance management system that enables:
- **ID Card Scanning**: Extract user information from ID cards using OCR and ML models
- **Session Management**: Admins create and manage attendance sessions
- **Proximity Check-in**: Users discover nearby sessions via mDNS/network scanning and check in
- **User Profiles**: Manage user information and view attendance statistics

## 🏗️ Architecture

The app follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── core/                    # Shared core functionality
│   ├── DI/                 # Dependency Injection (GetIt)
│   ├── networking/         # API client, error handling
│   ├── routing/           # Navigation & routes
│   ├── services/          # Auth, location, permissions
│   ├── themes/            # Colors, text styles
│   ├── utils/             # Utilities & helpers
│   ├── widgets/           # Reusable widgets
│   └── curren_user/       # Current user feature (shared)
│
└── features/              # Feature modules
    ├── auth/              # Registration
    ├── attendance/        # User check-in & session discovery
    ├── ocr/               # ID card scanning & OCR
    ├── onboarding/       # Onboarding flow
    ├── profile/           # User profile management
    ├── session_mangement/ # Admin session management
    ├── splash/            # Splash screen
    └── verification/      # User verification
```

Each feature follows the **data/domain/presentation** pattern:
- **data**: Models, repositories implementation, services
- **domain**: Entities, repositories interfaces, use cases
- **presentation**: UI (screens, widgets), state management (Cubit/Bloc)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.9.2`
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- iOS development: Xcode (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Mobile_App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (for freezed, json_serializable, etc.)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (Cubit/Bloc) |
| `get_it` | Dependency injection |
| `dio` | HTTP client for API calls |
| `hive` / `hive_flutter` | Local database (user data, auth state) |
| `camera` | Camera access for OCR |
| `tflite_flutter` | TensorFlow Lite for ML models |
| `flutter_tesseract_ocr` | OCR text extraction |
| `geolocator` | Location services |
| `nsd` | Network Service Discovery (mDNS) |
| `permission_handler` | Runtime permissions |
| `flutter_screenutil` | Responsive UI scaling |

## 🔑 Features

### 1. **Onboarding & Registration**
- Welcome screen with app introduction
- ID card scanning via OCR
- User registration with organization code
- Email/password authentication

### 2. **OCR (ID Card Scanning)**
- Real-time camera preview
- ML-based card detection (TensorFlow Lite)
- Field detection and cropping
- Text extraction (Tesseract OCR + ML digit recognition)
- Data validation and saving

### 3. **Session Management (Admin)**
- Create attendance sessions
- Configure session details (name, location, time, radius)
- Start/stop local HTTP server for check-ins
- View real-time attendance list
- Session statistics

### 4. **Attendance (User)**
- Discover nearby sessions (mDNS + network scanning)
- Check-in to active sessions
- View attendance history
- View attendance statistics

### 5. **Profile Management**
- View user information
- Update profile image
- Edit user details
- View organization information

## 🔐 Authentication Flow

1. **First Launch**: User sees onboarding → scans ID card → registers
2. **Subsequent Launches**: App checks auth state:
   - If logged in → Main navigation (Home/Profile)
   - If not logged in → Registration screen
   - If OCR not completed → Onboarding screen

Authentication state is stored in **Hive** (`AuthStateModel`).

## 🌐 API Integration

The app communicates with a backend API for:
- User registration
- Session creation/management
- Attendance check-in
- User statistics

API configuration:
- Base URL: Defined in `lib/core/networking/api_const.dart`
- Authentication: Token-based (stored in Dio interceptor)
- Error handling: Centralized in `api_error_handler.dart`

## 💾 Local Storage

**Hive** is used for:
- User data (`UserModel`)
- Authentication state (`AuthStateModel`)
- Organization data (`OrganizationModel`, `UserOrgModel`)


## 📱 Permissions Required

- **Camera**: For ID card scanning
- **Location**: For proximity-based check-in
- **Storage**: For saving images and data

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📝 Code Generation

This project uses code generation for:
- **Freezed**: Immutable data classes (`api_error_model.freezed.dart`)
- **json_serializable**: JSON serialization (`.g.dart` files)
- **Hive**: Type adapters (`.g.dart` files)

After modifying models, regenerate:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Documentation

- **[Features & Data Flow](./docs/FEATURES_AND_DATA_FLOW.md)**: Detailed feature documentation with data flow diagrams

## 🤝 Contributing

1. Follow the existing architecture (data/domain/presentation)
2. Use Cubit/Bloc for state management
3. Keep domain layer framework-agnostic
4. Write use cases for business logic
5. Use dependency injection (GetIt)

## 📄 License

[Add your license here]

## 👥 Team

[Add team/author information]

---

