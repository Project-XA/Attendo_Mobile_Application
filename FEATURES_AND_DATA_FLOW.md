# Features & Data Flow Documentation

This document provides detailed information about each feature in the Attendency mobile app, including data flows, architecture, and component interactions.

---

## Table of Contents

1. [App Initialization Flow](#app-initialization-flow)
2. [Onboarding & Registration](#onboarding--registration)
3. [OCR Feature (ID Card Scanning)](#ocr-feature-id-card-scanning)
4. [Session Management (Admin)](#session-management-admin)
5. [Attendance Feature (User)](#attendance-feature-user)
6. [Profile Management](#profile-management)
7. [Authentication & State Management](#authentication--state-management)

---

## App Initialization Flow

### Overview
The app initializes core dependencies, checks authentication state, and routes users to the appropriate screen.

### Flow Diagram

```
main.dart
  ↓
AppBootstrap (initState)
  ↓
initCore() [DI Setup]
  ├─ Hive initialization
  ├─ Network service (Dio)
  ├─ Data sources (local/remote)
  └─ Services (AuthStateService, OnboardingService)
  ↓
OnboardingService checks:
  ├─ hasCompletedOCR()?
  ├─ hasCompletedOnboarding()?
  └─ isLoggedIn()?
  ↓
Determine initial route:
  ├─ Routes.startPage (if OCR not done)
  ├─ Routes.registerScreen (if not registered/logged in)
  └─ Routes.mainNavigation (if logged in)
  ↓
AttendencyApp
  └─ MaterialApp with AppRoute
```

### Components

**File**: `lib/main.dart`
- Registers Hive adapters
- Initializes Flutter bindings
- Runs `AppBootstrap`

**File**: `lib/core/app_boot_strap.dart`
- `_init()`: Sets up core DI and determines initial route
- Shows animated splash screen during initialization
- Routes to appropriate screen based on auth state

**File**: `lib/core/DI/get_it.dart`
- `initCore()`: Registers core dependencies
  - Hive box for user data
  - Dio HTTP client
  - NetworkService
  - UserLocalDataSource / UserRemoteDataSource
  - AuthStateService / OnboardingService

**File**: `lib/core/services/auth/onboarding_service.dart`
- Manages onboarding state (OCR completion, registration, login)
- Uses `AuthStateService` (Hive) for persistence

---

## Onboarding & Registration

### Feature Overview
Users are guided through:
1. Welcome/onboarding screen
2. ID card scanning (OCR)
3. Registration with organization code

### Data Flow: Registration

```
RegisterScreen
  ↓
RegisterForm (UI)
  ├─ User inputs: orgId, email, password
  └─ Gets localUserData (from OCR scan)
  ↓
RegisterCubit.register()
  ↓
RegisterUseCase.call()
  ↓
RegisterRepoImp.registerUser()
  ├─ Validates orgId
  ├─ Creates RegisterRequestBody
  ├─ Calls UserRemoteDataSource.registerUser()
  │   └─ POST /api/register
  │       └─ Returns RegisterResponseBody
  ├─ Merges API response + local OCR data
  ├─ Creates complete UserModel
  ├─ Saves to UserLocalDataSource.saveUserLogin()
  ├─ Sets auth token in DioFactory
  ├─ Marks onboarding complete (OnboardingService)
  └─ Returns ApiResult<UserModel>
  ↓
RegisterCubit emits:
  ├─ RegisterLoadedState (success)
  └─ RegisterFailureState (error)
  ↓
Navigation to MainNavigationScreen
```

### Components

**Presentation Layer**:
- `lib/features/auth/presentation/register_screen.dart`
- `lib/features/auth/presentation/widgets/register_form.dart`
- `lib/features/auth/presentation/logic/register_cubit.dart`
- `lib/features/auth/presentation/logic/register_state.dart`

**Domain Layer**:
- `lib/features/auth/domain/repos/register_repo.dart` (interface)
- `lib/features/auth/domain/use_cases/register_use_case.dart`

**Data Layer**:
- `lib/features/auth/data/repo_imp/register_repo_imp.dart`
- `lib/features/auth/data/models/register_request_body.dart`
- `lib/features/auth/data/models/register_response_body.dart`
- `lib/core/curren_user/Data/remote_data_source/user_remote_data_source.dart`

### Key Data Models

**RegisterRequestBody**:
```dart
{
  organizationCode: int,
  email: String,
  password: String
}
```

**RegisterResponseBody**:
```dart
{
  loginToken: String,
  userResponse: {
    id: int,
    email: String,
    username: String,
    fullName: String,
    organizationId: int,
    organizationName: String,
    role: String
  }
}
```

**UserModel** (merged):
- From API: id, email, username, firstNameEn, lastNameEn, loginToken, organizations
- From OCR: nationalId, firstNameAr, lastNameAr, address, birthDate, idCardImage

---

## OCR Feature (ID Card Scanning)

### Feature Overview
Scans ID cards using camera, detects fields with ML models, extracts text with OCR, and saves extracted data.

### Data Flow: Card Scanning

```
ScanIdScreen
  ↓
CameraCubit.openCamera()
  ├─ Checks camera permission
  ├─ CameraRepImp.openCamera()
  │   ├─ Loads ML models (CardServiceModel, FieldServiceModel, IdServiceModel)
  │   └─ Initializes OcrService (Tesseract)
  └─ Emits CameraState (isOpened: true)
  ↓
User taps capture
  ↓
CameraCubit.capturePhoto()
  ├─ CapturePhotoUseCase.execute()
  │   └─ CameraRepImp.capturePhoto()
  │       └─ Returns CapturedPhoto(path)
  ├─ Closes camera
  ├─ ValidateCardUseCase.execute(photo)
  │   └─ CameraRepImp.isCard(photo)
  │       ├─ InferenceService.detectCard()
  │       └─ Returns bool (isCardDetected)
  ├─ If invalid card → emit invalid message → reopen camera
  ├─ CameraRepImp.detectFields(photo)
  │   └─ ObjectDetectionService.detectFields()
  │       └─ Returns List<DetectionModel>
  ├─ ValidateRequiredFieldsUseCase.execute(detections)
  │   └─ Checks required fields (photo, firstName, lastName)
  │   └─ Returns ValidationResult
  ├─ If missing fields → emit error → reopen camera
  ├─ ProcessCardUseCase.execute(photo)
  │   ├─ detectFields()
  │   ├─ cropDetectedFields() → List<CroppedField>
  │   └─ extractFinalData() → Map<String, String>
  └─ Emits CameraState (showResult: true, finalData: {...})
  ↓
User verifies and saves
  ↓
CameraCubit.verifyAndSaveData()
  ├─ SaveScannedCardUseCase.execute(finalData)
  │   └─ Maps OCR data to UserModel
  │   └─ UserLocalDataSource.saveLocalUserData()
  └─ OnboardingService.markOCRComplete()
```

### Components

**Presentation Layer**:
- `lib/features/ocr/presentation/scan_id_screen.dart`
- `lib/features/ocr/presentation/logic/camera_cubit.dart`
- `lib/features/ocr/presentation/logic/camera_state.dart`
- `lib/features/ocr/presentation/widgets/` (camera_box, id_data_widget, etc.)

**Domain Layer**:
- `lib/features/ocr/domain/repo/camera_repo.dart`
- `lib/features/ocr/domain/usecases/` (captured_photo, validate_card, process_card, etc.)

**Data Layer**:
- `lib/features/ocr/data/repo_imp/camera_reo_imp.dart`
- `lib/features/ocr/data/services/`:
  - `object_detect_service.dart` (field detection)
  - `crop_service.dart` (field cropping)
  - `ocr_service.dart` (Tesseract OCR)
  - `digital_recognition_service.dart` (ML digit recognition)
  - `field_processing_service.dart` (orchestrates extraction)
  - `inference_service.dart` (card detection)
- `lib/features/ocr/data/model/ml_models/` (TFLite model wrappers)

### ML Models Used

1. **Card Detection Model** (`detect_id_card_float32.tflite`)
   - Detects if image contains an ID card
   - Confidence threshold: 0.3

2. **Field Detection Model** (`detect_odjects_float32.tflite`)
   - Detects field bounding boxes (firstName, lastName, nid, etc.)
   - Confidence threshold: 0.5

3. **ID Recognition Model** (`detect_id_float32.tflite`)
   - Recognizes digits (for NID, dates, serial numbers)
   - Confidence threshold: 0.1

### OCR Pipeline

1. **Preprocessing**: Image resizing, normalization (640x640)
2. **Card Detection**: ML model checks if card is present
3. **Field Detection**: ML model detects field locations
4. **Cropping**: Extract individual field images
5. **Text Extraction**:
   - Numeric fields (NID, dates) → ML digit recognition
   - Text fields → Tesseract OCR (Arabic/English)
6. **Validation**: Check required fields are present
7. **Data Mapping**: Map extracted text to UserModel fields

---

## Session Management (Admin)

### Feature Overview
Admins create attendance sessions, start a local HTTP server, and monitor real-time check-ins.

### Data Flow: Create & Start Session

```
AdminDashboard
  ↓
SessionMangementCubit.createAndStartSession()
  ├─ Creates placeholder Session (domain entity)
  ├─ Emits SessionState (operation: creating)
  ├─ CreateSessionUseCase.call()
  │   └─ SessionRepositoryImpl.createSession()
  │       ├─ Gets current user (UserLocalDataSource)
  │       ├─ Creates CreateSessionRequestModel
  │       ├─ UserRemoteDataSource.createSession()
  │       │   └─ POST /api/sessions
  │       │       └─ Returns sessionId
  │       └─ Returns Session entity
  ├─ Emits SessionState (operation: starting)
  ├─ StartSessionServerUseCase.call(sessionId)
  │   └─ SessionRepositoryImpl.startSessionServer()
  │       └─ HttpServerService.startServer()
  │           ├─ Binds HTTP server (port 8080)
  │           ├─ Registers mDNS service ("attendance")
  │           ├─ Sets up request handlers:
  │           │   ├─ GET /health → session status
  │           │   ├─ GET /session-info → session details
  │           │   └─ POST /check-in → attendance check-in
  │           └─ Returns ServerInfo (ipAddress, port)
  └─ Emits SessionState (operation: active)
  ↓
ListenAttendanceUseCase.call()
  └─ SessionRepositoryImpl.getAttendanceStream()
      └─ HttpServerService.attendanceStream
          └─ Stream<AttendanceRecord>
  ↓
SessionMangementCubit listens to stream
  ├─ Updates session.attendanceList
  ├─ Updates session.connectedClients count
  └─ Emits updated SessionState
```

### Data Flow: Check-in Request (from User)

```
User app → HTTP POST http://<admin-ip>:8080/check-in
  Body: {
    userId: String,
    userName: String,
    location: String,
    timestamp: String
  }
  ↓
HttpServerService._handleRequest()
  ├─ Validates location (within allowed radius)
  ├─ Creates AttendanceRequest
  ├─ Adds to attendanceStream
  └─ Returns 200 OK / 400 Bad Request
  ↓
SessionRepositoryImpl.getAttendanceStream()
  ├─ Maps AttendanceRequest → AttendanceRecord
  ├─ Updates _currentSession.attendanceList
  └─ Emits AttendanceRecord
  ↓
SessionMangementCubit receives update
  └─ Updates UI (attendance list widget)
```

### Components

**Presentation Layer**:
- `lib/features/session_mangement/presentation/admin_dashboard.dart`
- `lib/features/session_mangement/presentation/logic/session_management_cubit.dart`
- `lib/features/session_mangement/presentation/logic/session_management_state.dart`
- `lib/features/session_mangement/presentation/widgets/` (create_session_form, active_session_view, attendance_list_widget, etc.)

**Domain Layer**:
- `lib/features/session_mangement/domain/repos/session_repository.dart`
- `lib/features/session_mangement/domain/entities/session.dart`
- `lib/features/session_mangement/domain/entities/server_info.dart`
- `lib/features/session_mangement/domain/use_cases/` (create_session, start_session_server, end_session, listen_attendence)

**Data Layer**:
- `lib/features/session_mangement/data/repo_imp/session_repository_impl.dart`
- `lib/features/session_mangement/data/service/http_server_service.dart`
- `lib/features/session_mangement/data/service/network_info_service.dart`
- `lib/features/session_mangement/data/models/` (attendency_record, remote_models)

### Key Entities

**Session**:
```dart
{
  id: int,
  name: String,
  location: String,
  connectionMethod: String,
  startTime: DateTime,
  durationMinutes: int,
  status: SessionStatus (inactive/active/ended),
  connectedClients: int,
  attendanceList: List<AttendanceRecord>
}
```

**ServerInfo**:
```dart
{
  ipAddress: String,
  port: int,
  sessionId: int
}
```

**AttendanceRecord**:
```dart
{
  userId: String,
  userName: String,
  location: String,
  timestamp: DateTime
}
```

---

## Attendance Feature (User)

### Feature Overview
Users discover nearby active sessions and check in to them.

### Data Flow: Session Discovery

```
UserDashboardScreen
  ↓
UserCubit.startSessionDiscovery()
  ├─ Emits SessionDiscoveryActive (isSearching: true)
  ├─ StartDiscoveryUseCase.call()
  │   └─ SessionDiscoveryRepoImpl.startDiscovery()
  │       └─ SessionDiscoveryService.startDiscovery()
  │           ├─ Starts mDNS discovery ("_http._tcp")
  │           ├─ Starts network scanning (local subnet)
  │           └─ Scans IPs: <network>.1-20, <network>.100-254
  ├─ DiscoverSessionsUseCase.call()
  │   └─ Returns Stream<NearbySession>
  └─ UserCubit listens to stream
      ├─ On session found:
      │   ├─ Cancels search timeout
      │   ├─ Adds to discoveredSessions list
      │   └─ Emits SessionDiscoveryActive (updated list)
      └─ On timeout (no sessions):
          └─ Emits SessionDiscoveryActive (isSearching: false)
```

### Session Discovery Methods

1. **mDNS Discovery**:
   - Listens for "_http._tcp" services
   - Filters by service name "attendance"
   - Resolves service → IP:port

2. **Network Scanning**:
   - Gets local IP address
   - Scans subnet (e.g., 192.168.1.1-254)
   - Checks `/health` endpoint on port 8080
   - Validates response (status: "active", sessionId present)
   - Fetches `/session-info` for full details

### Data Flow: Check-in

```
User taps "Check In" on discovered session
  ↓
UserCubit.checkIn(session, userId, userName)
  ├─ Emits CheckInState (operation: checkingIn)
  ├─ CheckInUseCase.call()
  │   └─ UserAttendenceRepoImpl.checkIn()
  │       └─ AttendenceService.checkIn()
  │           ├─ Validates location (within session radius)
  │           ├─ HTTP POST http://<session-ip>:8080/check-in
  │           │   Body: { userId, userName, location, timestamp }
  │           └─ Returns CheckInResponse (success: bool, message: String)
  ├─ If success:
  │   ├─ GetAttendanceStatsUseCase.call()
  │   │   └─ UserRemoteDataSource.getUserStatistics()
  │   │       └─ GET /api/users/statistics
  │   ├─ Emits CheckInState (operation: success)
  │   └─ After 2s → stop discovery → emit UserIdle
  └─ If failed:
      ├─ Emits CheckInState (operation: failed)
      └─ After 2s → stop discovery
```

### Components

**Presentation Layer**:
- `lib/features/attendance/presentation/user_dashboard_screen.dart`
- `lib/features/attendance/presentation/logic/user_cubit.dart`
- `lib/features/attendance/presentation/logic/user_state.dart`
- `lib/features/attendance/presentation/widgets/` (active_session_card, no_session_card, searching_session_card, etc.)

**Domain Layer**:
- `lib/features/attendance/domain/repos/session_discovery_repo.dart`
- `lib/features/attendance/domain/repos/user_attendence_repo.dart`
- `lib/features/attendance/domain/entities/nearby_session.dart`
- `lib/features/attendance/domain/entities/attendency_state.dart`
- `lib/features/attendance/domain/use_cases/` (discover_session, check_in, get_attendence_status, etc.)

**Data Layer**:
- `lib/features/attendance/data/repos_imp/session_discovery_repo_impl.dart`
- `lib/features/attendance/data/repos_imp/user_attendence_repo_impl.dart`
- `lib/features/attendance/data/services/session_discovery_service.dart`
- `lib/features/attendance/data/services/attendence_service.dart`
- `lib/features/attendance/data/models/` (nearby_session_model, discover_session_model, etc.)

### Key Entities

**NearbySession**:
```dart
{
  sessionId: int,
  name: String,
  location: String,
  ipAddress: String,
  port: int,
  baseUrl: String (http://ip:port)
}
```

**UserState** (sealed):
- `UserIdle`: No active discovery
- `SessionDiscoveryActive`: Searching for sessions
- `CheckInState`: Check-in in progress/success/failed

---

## Profile Management

### Feature Overview
Users can view and edit their profile information.

### Data Flow: Load Profile

```
ProfileScreen
  ↓
CurrentUserCubit (from core)
  ├─ Loads current user on init
  ├─ UserLocalDataSource.getCurrentUser()
  └─ Emits CurrentUserState (user: UserModel)
  ↓
ProfileScreen displays user data
```

### Data Flow: Update Profile

```
User edits field (e.g., address)
  ↓
ProfileInfoCard → CurrentUserCubit.updateUser()
  ├─ UpdateUserUseCase.call()
  │   └─ CurrentUserRepo.updateUser()
  │       ├─ Maps User entity → UserModel
  │       ├─ UserLocalDataSource.updataUser()
  │       ├─ UserRemoteDataSource.updateUser()
  │       │   └─ PUT /api/users/{id}
  │       └─ Returns updated User
  └─ Emits CurrentUserState (updated user)
```

### Components

**Presentation Layer**:
- `lib/features/profile/presentation/profile_screen.dart`
- `lib/features/profile/presentation/widgets/` (profile_body, profile_info_card, profile_image_section, etc.)

**Domain Layer** (shared in core):
- `lib/core/curren_user/domain/repo/current_user_repo.dart`
- `lib/core/curren_user/domain/use_case/update_user_use_case.dart`
- `lib/core/curren_user/domain/entities/user.dart`

**Data Layer** (shared in core):
- `lib/core/curren_user/Data/repo_imp/current_user_repo_imp.dart`
- `lib/core/curren_user/Data/local_data_soruce/user_local_data_source.dart`
- `lib/core/curren_user/Data/remote_data_source/user_remote_data_source.dart`

---

## Authentication & State Management

### Auth State Storage

**Hive Box**: `auth_state_box`
- Key: `auth_state`
- Model: `AuthStateModel`
  ```dart
  {
    hasCompletedOCR: bool,
    hasRegistered: bool,
    isLoggedIn: bool,
    userRole: String?
  }
  ```

### Auth Flow States

1. **First Launch**:
   - `hasCompletedOCR = false` → Routes to `StartPage`

2. **After OCR**:
   - `hasCompletedOCR = true`
   - `hasRegistered = false` → Routes to `RegisterScreen`

3. **After Registration**:
   - `hasRegistered = true`
   - `isLoggedIn = true`
   - `userRole = "Admin" | "User"` → Routes to `MainNavigationScreen`

4. **Subsequent Launches**:
   - If `isLoggedIn = true` → Routes to `MainNavigationScreen`
   - If `isLoggedIn = false` → Routes to `RegisterScreen`

### Token Management

- **Storage**: Token stored in `UserModel.loginToken` (Hive)
- **API Requests**: Token added to Dio interceptor (`DioFactory.setToken()`)
- **Headers**: `Authorization: Bearer <token>`

### Services

**AuthStateService** (`lib/core/services/auth/auth_state_service.dart`):
- Manages auth state in Hive
- Methods: `hasCompletedOCR()`, `markOCRComplete()`, `hasRegistered()`, `markRegistrationComplete()`, `isLoggedIn()`, `markLoggedIn()`, `getUserRole()`

**OnboardingService** (`lib/core/services/auth/onboarding_service.dart`):
- Wraps `AuthStateService` with business logic
- Used by `AppBootstrap` to determine initial route

---

## Data Flow Summary Diagrams

### Registration Flow
```
UI → Cubit → UseCase → Repository → RemoteDataSource → API
                                    ↓
                              LocalDataSource ← Hive
```

### OCR Flow
```
Camera → Capture → Validate Card → Detect Fields → Crop → Extract Text → Save
         ↓           ↓                ↓            ↓        ↓              ↓
      Photo      ML Model        ML Model      Image    OCR/ML         Hive
```

### Session Discovery Flow
```
UserCubit → UseCase → Repository → Service
                              ├─ mDNS Discovery
                              └─ Network Scan → HTTP GET /health
                                              → HTTP GET /session-info
```

### Check-in Flow
```
UserCubit → UseCase → Repository → Service → HTTP POST /check-in
                                                      ↓
                                              Admin HTTP Server
                                                      ↓
                                              AttendanceStream
                                                      ↓
                                              Admin UI Updates
```

---

## Key Design Patterns

1. **Clean Architecture**: Clear separation (data/domain/presentation)
2. **Dependency Injection**: GetIt for DI
3. **State Management**: Cubit/Bloc pattern
4. **Repository Pattern**: Abstraction over data sources
5. **Use Cases**: Business logic encapsulation
6. **Streams**: Real-time updates (attendance, session discovery)

---

**Last Updated**: January 2025
