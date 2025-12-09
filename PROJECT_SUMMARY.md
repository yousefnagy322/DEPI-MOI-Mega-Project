# MOI Reporting Application - Detailed Project Summary

## Project Overview

**MOI Reporting Application** (migaproject) is a comprehensive Flutter-based mobile and web application designed for citizens to report various issues to government authorities. The application provides a dual-interface system: one for regular users to submit reports and another for administrators/officers to manage and analyze these reports.

## Technology Stack

### Core Framework
- **Flutter SDK**: ^3.9.2
- **Dart**: Modern Dart language features
- **Platform Support**: Android, iOS, Web, Windows, Linux, macOS

### Key Dependencies
- **State Management**: `flutter_bloc` (^9.1.1) - BLoC pattern for state management
- **HTTP Client**: `dio` (^5.9.0) - For API communication
- **Location Services**: `geolocator` (^14.0.2) - GPS location tracking
- **Media Handling**: 
  - `image_picker` (^1.2.1) - Image and video selection
  - `video_player` (^2.10.1) - Video playback
  - `video_thumbnail` (^0.5.6) - Video thumbnail generation
- **Data Visualization**: `fl_chart` (^0.69.0) - Charts and analytics
- **UI Components**: 
  - `google_fonts` (^6.3.2) - Typography
  - `cupertino_icons` (^1.0.8) - iOS-style icons
- **Utilities**: 
  - `shared_preferences` (^2.5.3) - Local storage
  - `intl` (^0.20.2) - Internationalization
  - `url_launcher` (^6.3.0) - External URL handling
  - `equatable` (^2.0.7) - Value equality

### Backend Integration
- **Base URL**: `https://moi-reporting-app-f2hwfsdaddexgcak.germanywestcentral-01.azurewebsites.net`
- **Deployment**: Azure App Service (Germany West Central)
- **API Version**: v1

## Application Architecture

### Project Structure

```
lib/
├── core/                    # Core utilities and configurations
│   └── api_paths.dart      # API endpoint definitions
├── Data/                    # Data models
│   ├── report_model.dart   # Report and attachment models
│   ├── user_model.dart     # User data model
│   ├── analytics_model.dart # Analytics and statistics models
│   ├── count_model.dart    # Count/statistics models
│   └── analyricline_model.dart # Line chart analytics model
├── Logic/                   # Business logic (BLoC/Cubit)
│   ├── login/              # Authentication logic
│   ├── signup/             # Registration logic
│   ├── new_report/         # Report creation logic
│   ├── user_reports_list/  # User's reports listing
│   ├── officer_reports_list/ # Officer's reports management
│   ├── officer_report_details/ # Report details for officers
│   ├── user_data_list/     # User management logic
│   ├── user_role_change/   # Role management logic
│   ├── analytics/          # Analytics data logic
│   └── analytic_line_chart/ # Chart data logic
└── presentation/            # UI layer
    ├── screens/            # Main application screens
    │   ├── Auth_screens/   # Login and signup
    │   ├── Report_Form/    # Report creation screens
    │   ├── my_reports/     # User's reports view
    │   ├── officer_dashboard/ # Officer interface
    │   ├── report_review/  # Report review screen
    │   ├── Report_Submitted/ # Submission confirmation
    │   └── Splash/         # Splash screen
    ├── admin/              # Admin panel screens
    │   ├── admin_login_screen.dart
    │   ├── admin_home.dart
    │   ├── dashboard_page.dart
    │   ├── reports_page.dart
    │   ├── analytics_page.dart
    │   ├── users_page.dart
    │   └── widgets/        # Admin-specific widgets
    └── widgets/            # Reusable UI components
```

## Core Features

### 1. User Authentication
- **Login**: Email/password authentication
- **Signup**: User registration with email and phone number
- **Session Management**: Token-based authentication with local storage
- **Role-Based Access**: Different interfaces for users, officers, and admins

### 2. Report Submission System

#### Report Categories
Users can submit reports in the following categories:
1. **Traffic** - Traffic violations, accidents, road issues
2. **Crime** - Criminal activities, theft, security concerns
3. **Public Nuisance** - Noise complaints, public disturbances
4. **Utilities** - Water, electricity, gas, and other utility issues
5. **Infrastructure** - Road damage, missing infrastructure, public facilities
6. **Environmental** - Environmental concerns, pollution, waste management
7. **Other** - Miscellaneous issues

#### Report Features
- **Title and Description**: Text-based report details
- **Category Selection**: Categorized reporting
- **Location Tracking**: Automatic GPS location capture using Geolocator
- **Media Attachments**:
  - Multiple image uploads
  - Video uploads with thumbnail generation
  - Support for various file formats
- **Voice Transcription**: Optional voice-to-text feature for report descriptions
- **Anonymous Reporting**: Option to submit reports anonymously
- **Device ID Hashing**: Privacy-focused device identification

#### Report Status Workflow
Reports progress through the following statuses:
1. **Submitted** - Initial submission
2. **Assigned** - Assigned to an officer
3. **InProgress** - Under investigation/review
4. **Resolved** - Issue resolved
5. **Rejected** - Report rejected (with reason)

### 3. User Interface (Mobile App)

#### Main Features
- **Splash Screen**: Initial loading screen
- **Category Selection**: Grid-based category picker with icons
- **Report Form**: Comprehensive form with:
  - Text input fields
  - Media picker (images/videos)
  - Location display
  - Voice recording option
  - Anonymous toggle
- **Report Review**: Preview before submission
- **My Reports**: User's submitted reports list with:
  - Status tracking
  - Report details
  - Timeline view
- **Report Details**: Full report information with attachments

### 4. Officer Dashboard

#### Features
- **Dashboard Overview**: 
  - Recent reports
  - Status metrics
  - Quick statistics
- **Reports Management**:
  - List all reports
  - Filter by status/category
  - View report details
  - Update report status
  - View attachments (images/videos)
- **Report Details View**:
  - Full report information
  - Media viewer (images and videos)
  - Status update interface
  - User information (if not anonymous)

### 5. Admin Panel (Web Interface)

#### Dashboard
- **Metrics Cards**: 
  - Total reports
  - Total users
  - Reports by status
  - Category-wise statistics
- **Recent Reports Table**: Latest submissions with quick actions
- **Responsive Design**: Adapts to different screen sizes

#### Reports Management
- **Reports List**: Paginated list of all reports
- **Filtering**: Filter by status, category, date range
- **Search**: Search reports by title, description, or ID
- **Report Details**: Comprehensive report view with all information

#### Analytics
- **Category Statistics**: Reports count by category
- **Status Distribution**: Visual representation of report statuses
- **Hot Reports Matrix**: Category-wise status breakdown
- **Line Charts**: Trend analysis over time
- **Interactive Charts**: Using fl_chart library

#### User Management
- **User List**: Paginated user directory
- **User Details**: View user profiles
- **Role Management**: 
  - Change user roles (User, Officer, Admin)
  - Role badges and indicators
- **User Actions**:
  - Create new users
  - Edit user information
  - Delete users
  - Filter by role

#### Settings
- **System Configuration**: Application settings
- **Preferences**: Admin preferences

### 6. Data Models

#### Report Model
```dart
- title: String
- descriptionText: String
- categoryId: String
- location: String
- isAnonymous: bool
- transcribedVoiceText: String?
- hashedDeviceId: String?
- reportId: String?
- status: String?
- aiConfidence: double?
- createdAt: String?
- updatedAt: String?
- userId: String?
- attachments: List<Attachment>
- filesToUpload: List<File>?
```

#### Attachment Model
```dart
- attachmentId: String
- reportId: String
- blobStorageUri: String
- downloadUrl: String
- mimeType: String
- fileType: String
- fileSizeBytes: int
- createdAt: String
```

#### User Model
```dart
- userId: String
- email: String
- phoneNumber: String?
- role: String
- createdAt: DateTime
```

#### Analytics Model
- **CategoryStats**: Status counts per category
- **AnalyticsResponse**: Overall analytics data
- Status tracking: Submitted, Assigned, InProgress, Resolved, Rejected

## API Endpoints

### Authentication
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration

### Reports
- `GET /api/v1/reports/` - List all reports (with pagination)
- `GET /api/v1/reports/user/` - Get user's reports
- `POST /api/v1/reports/` - Create new report (multipart/form-data)

### Admin
- `GET /api/v1/users/list` - List all users
- `GET /api/v1/admin/dashboard/hot/categorycount` - Get analytics matrix

## State Management

The application uses **BLoC (Business Logic Component)** pattern with Cubits:
- **Separation of Concerns**: Logic separated from UI
- **Reactive Programming**: State changes trigger UI updates
- **State Classes**: Loading, Success, Error states for each feature
- **Cubit Pattern**: Simplified BLoC for simpler state management

## UI/UX Design

### Design System
- **Font**: Inter font family (variable font with multiple weights)
- **Color Scheme**: Blue-based color scheme (seedColor: Colors.blue[100])
- **Material Design**: Follows Material Design guidelines
- **Responsive**: Adapts to different screen sizes

### Key UI Components
- **Category Widgets**: Grid-based category selection cards
- **Status Badges**: Color-coded status indicators
- **Role Badges**: User role visualization
- **Metric Cards**: Dashboard statistics cards
- **Media Viewers**: Full-screen image and video viewers
- **Pagination Widgets**: For large data lists
- **Filter Bars**: Advanced filtering interfaces

## Security Features

- **Device ID Hashing**: Privacy protection for anonymous reports
- **Token-Based Authentication**: Secure session management
- **Anonymous Reporting**: Privacy option for users
- **Role-Based Access Control**: Different permissions for different roles

## Media Handling

- **Image Support**: Multiple image formats
- **Video Support**: Video upload with automatic thumbnail generation
- **Blob Storage**: Files stored in Azure Blob Storage
- **Download URLs**: Secure download links for attachments
- **Thumbnail Generation**: Automatic video thumbnail creation

## Platform-Specific Features

### Android
- Native Android build configuration
- Gradle-based build system
- Android-specific permissions handling

### iOS
- Xcode project configuration
- iOS-specific permissions (camera, location, microphone)
- Swift bridging headers

### Web
- Web-optimized admin interface
- Responsive web design
- Web-specific API handling

## Development Tools

- **Linting**: `flutter_lints` (^5.0.0) for code quality
- **Testing**: Flutter test framework
- **Build Tools**: Gradle (Android), Xcode (iOS), CMake (Linux/Windows)

## Assets

### Images
- Category icons (Traffic, Crime, Noise, Utilities, Missing, Environment, Other, Corruption, Location, Recording, Mic)
- Report-related images

### Fonts
- Inter font family with multiple weights and styles
- Variable fonts for flexible typography

## Future Enhancements (Potential)

Based on the codebase structure, potential enhancements could include:
- Push notifications for report status updates
- Real-time chat between users and officers
- Advanced AI-based report categorization
- Map integration for location visualization
- Report sharing capabilities
- Multi-language support
- Offline mode for report submission
- Advanced analytics and reporting

## Deployment

- **Backend**: Azure App Service (Germany West Central)
- **Frontend**: Flutter applications for multiple platforms
- **Storage**: Azure Blob Storage for media files
- **API**: RESTful API architecture

## Project Status

The project appears to be in active development with:
- Complete authentication system
- Full report submission workflow
- Admin and officer dashboards
- Analytics and reporting features
- Multi-platform support

---

**Note**: This is a comprehensive reporting system designed for government/civic use, allowing citizens to report issues and authorities to manage and respond to them efficiently.

