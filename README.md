![MOI Digital Report System Banner](readme assets/banner.jpg)

# DEPI MOI Digital Report System 📊

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-orange)

A **cross-platform Flutter application** that enables citizens to report issues to government authorities digitally, with dedicated interfaces for **Users**, **Officers**, and **Administrators**.  
The system supports **real-time reporting**, **media attachments**, **analytics dashboards**, and **secure role-based access control**.

---

## 🌟 Key Features

### 👤 User Features
- Submit reports in categories:
  - Traffic
  - Crime
  - Public Nuisance
  - Utilities
  - Infrastructure
  - Environmental
  - Other
- Attach **images, videos, or voice-to-text** descriptions
- Automatic **GPS location capture**
- **Anonymous reporting** using privacy-focused device ID hashing
- Track report status:
  - Submitted → Assigned → In Progress → Resolved / Rejected

---

### 🧑‍✈️ Officer Dashboard
- View and manage incoming reports
- Filter reports by **category, status, and date**
- Update report status and add notes
- Access report details including media and location
- Overview dashboard with **recent reports and quick metrics**

---

### 🛡 Admin Panel (Web)
- User & role management (User / Officer / Admin)
- Advanced reports analytics with **charts & statistics**
- Category-based and status-based insights
- System configuration & preferences
- Fully responsive web interface

---

### 📊 Analytics & Insights
- Category-wise report statistics
- Report status distribution
- Trend analysis using **line charts**
- Interactive data visualization with `fl_chart`

---

## 🛠 Technology Stack

### Frontend
- **Flutter** ^3.9.2
- **Dart**
- **State Management**: BLoC (`flutter_bloc`)
- **UI & Fonts**: `google_fonts`, `cupertino_icons`

### Networking & Services
- **HTTP Client**: `dio`
- **Location Services**: `geolocator`
- **Media Handling**:
  - `image_picker`
  - `video_player`
  - `video_thumbnail`

### Analytics & Utilities
- **Charts**: `fl_chart`
- **Local Storage**: `shared_preferences`
- **Utilities**: `intl`, `url_launcher`, `equatable`

### Backend
- **Azure App Service**
- **RESTful API Architecture**

---

## 📂 Project Structure

```
lib/
├── core/                # Core utilities, constants & API paths
├── Data/                # Data models (reports, users, analytics)
├── Logic/               # BLoC / Cubit state management
└── presentation/        # UI screens & reusable widgets
```

---

## ⚡ Installation & Setup

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Emulator or physical device

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yousefnagy322/DEPI-MOI-Digital-Report-System.git
   ```

2. Navigate to the project directory:
   ```bash
   cd DEPI-MOI-Digital-Report-System
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

> ⚠️ **Note:**  
> Configure the backend API base URL inside `api_paths.dart` before running the app.

---

## 🎨 Screenshots / Demo

### 📱 Mobile Application
![Splash Screen](link-to-screenshot)
![Report Form](link-to-screenshot)
![Report Tracking](link-to-screenshot)

### 🧑‍✈️ Officer Dashboard
![Officer Dashboard](link-to-screenshot)

### 🛡 Admin Panel (Web)
![Admin Analytics](link-to-screenshot)

---

## 🔒 Security & Privacy
- Anonymous reporting via **hashed device identifiers**
- Token-based authentication
- Secure role-based authorization
- Privacy-focused system design

---

## 🚀 Future Enhancements
- Push notifications for report updates
- Real-time chat between users and officers
- AI-based automatic report categorization
- Map-based report visualization
- Offline reporting mode
- Multi-language support

---

## 📈 API Endpoints (Examples)

- `POST /api/v1/auth/login` – User login
- `POST /api/v1/auth/register` – User registration
- `GET /api/v1/reports` – Retrieve reports
- `POST /api/v1/reports` – Submit a new report

Full API documentation is available in the codebase.

---

## 👨‍💻 Author

**Yousef Nagy**

- 📧 Email: [yousefnagy322@gmail.com](mailto:yousefnagy322@gmail.com)
- 💻 GitHub: [yousefnagy322](https://github.com/yousefnagy322)

---

⭐ **Thank you for checking out this project!**  
This system aims to modernize civic issue reporting and improve communication between citizens and government authorities.
