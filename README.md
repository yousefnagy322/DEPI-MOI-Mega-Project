# DEPI MOI Digital Report System 📊

![Project Banner](link-to-banner-or-screenshot)

A **cross-platform Flutter application** for citizens to report issues to government authorities, with separate interfaces for users, officers, and admins. The app supports real-time reporting, media attachments, analytics, and role-based access control.

---

## 🌟 Key Features

### User Features

* Submit reports in categories: Traffic, Crime, Public Nuisance, Utilities, Infrastructure, Environmental, Other
* Add **images, videos, or voice-to-text** descriptions
* Automatic **GPS location capture**
* **Anonymous reporting** with privacy-focused device ID hashing
* Track report status: Submitted → Assigned → In Progress → Resolved/Rejected

### Officer Dashboard

* Manage incoming reports with **filters and status updates**
* View **report details and attachments**
* Dashboard overview with **recent reports and metrics**

### Admin Panel (Web)

* User and role management (User, Officer, Admin)
* Reports analytics with **charts and category statistics**
* System settings and preferences
* Responsive design for multiple screen sizes

### Analytics

* Category-wise report statistics
* Status distribution charts
* Trend analysis with **line charts**
* Interactive data visualization using `fl_chart`

---

## 🛠 Technology Stack

* **Flutter** ^3.9.2, **Dart**
* **State Management**: BLoC (`flutter_bloc`)
* **HTTP & API**: `dio`
* **Location Services**: `geolocator`
* **Media Handling**: `image_picker`, `video_player`, `video_thumbnail`
* **Charts & Analytics**: `fl_chart`
* **UI & Fonts**: `google_fonts`, `cupertino_icons`
* **Utilities**: `shared_preferences`, `intl`, `url_launcher`, `equatable`
* **Backend**: Azure App Service, REST API

---

## 📂 Project Structure

```
lib/
├── core/                # Core utilities & API paths
├── Data/                # Data models (reports, users, analytics)
├── Logic/               # BLoC/Cubit state management
└── presentation/        # Screens & reusable widgets
```

---

## ⚡ Installation & Setup

1. Clone the repo:

   ```bash
   git clone https://github.com/yousefnagy322/DEPI-MOI-Digital-Report-System.git
   ```
2. Navigate into the project:

   ```bash
   cd DEPI-MOI-Digital-Report-System
   ```
3. Install dependencies:

   ```bash
   flutter pub get
   ```
4. Run the app:

   ```bash
   flutter run
   ```

> **Note:** Configure the backend API URL in `api_paths.dart` before running.

---

## 🎨 Screenshots / Demo

![Splash Screen](link-to-screenshot)
![Report Form](link-to-screenshot)
![Officer Dashboard](link-to-screenshot)
![Admin Analytics](link-to-screenshot)

---

## 🚀 Future Enhancements

* Push notifications for report updates
* Real-time chat between users and officers
* AI-based report categorization
* Map integration and report sharing
* Offline reporting mode
* Multi-language support

---

## 🔒 Security Features

* Device ID hashing for anonymous reports
* Token-based authentication
* Role-based access control
* Privacy-focused design

---

## 📈 API Endpoints (Examples)

* `POST /api/v1/auth/login` – User login
* `POST /api/v1/auth/register` – User registration
* `GET /api/v1/reports/` – List all reports
* `POST /api/v1/reports/` – Submit a new report

Full API documentation available in the codebase.

---

## 👨‍💻 Author

**Yousef Nagy**

* Email: [yousefnagy322@gmail.com](mailto:yousefnagy322@gmail.com)
* GitHub: [yousefnagy322](https://github.com/yousefnagy322)

---

⭐ *Thanks for checking out this project! It’s a comprehensive civic reporting system designed to empower citizens and authorities.*
