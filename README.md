# 🚗 Road Radar

A real-time driver tracking application that connects passengers with nearby drivers. Road Radar enables location-based services with a clean, intuitive interface for users, drivers, and administrators.

## ✨ Features

### 👤 For Users
- View nearby drivers in real-time on an interactive map
- Track driver locations with automatic updates
- Simple and intuitive interface
- No registration required - just enter your name to get started

### 🚘 For Drivers
- Toggle location sharing with a simple switch
- Profile management with vehicle details
- Real-time location tracking
- View other drivers on the map

### 👑 For Admins
- Approve or reject driver registrations
- Monitor active drivers on a real-time map
- Manage driver accounts
- View comprehensive driver information

## 🛠️ Technology Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **Shared Preferences** - Local storage
- **Geolocator** - Location services
- **Flutter Map** - Map visualization

### Backend
- **Node.js** - Server runtime
- **Express** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM for MongoDB
- **REST API** - API architecture

## 📱 Screens

- **Onboarding** - Introduction to the app with role selection
- **Authentication** - Login and registration for drivers
- **User Home** - Map view with active drivers
- **Driver Home** - Location sharing toggle and map
- **Driver Profile** - Vehicle and personal information
- **Admin Dashboard** - Driver management and approval system

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6.0 or higher)
- Node.js (14.x or higher)
- MongoDB
- Android Studio / Xcode for device emulation

### Installation

#### Frontend
1. Clone the repository
```bash
git clone https://github.com/Mourya-2602/RoadRadar_ISM.git
cd RoadRadar_ISM
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Backend
The backend is deployed on Render:
```
https://roadradar-ism.onrender.com/api
```

## 🔄 API Endpoints

### Driver Endpoints
- `POST /api/drivers/register` - Register a new driver
- `POST /api/drivers/login` - Driver login
- `PUT /api/drivers/location` - Update driver location
- `PUT /api/drivers/status` - Toggle active status
- `GET /api/drivers/:id` - Get driver profile
- `PUT /api/drivers/:id` - Update driver profile

### Admin Endpoints
- `GET /api/admin/pending` - Get pending driver requests
- `GET /api/admin/active` - Get active drivers
- `PUT /api/admin/approve/:id` - Approve driver
- `PUT /api/admin/reject/:id` - Reject driver
- `DELETE /api/admin/drivers/:id` - Delete driver

### Location Endpoints
- `GET /api/locations` - Get all active driver locations

## 🔒 Authentication

- **Drivers**: Mobile number and password
- **Admin**: PIN-based authentication (123456)
- **Users**: No authentication required, just enter a name

## 📊 Architecture

The application follows a clean architecture pattern:

```
├── lib/
│   ├── config/       # App configuration, themes, routes
│   ├── models/       # Data models
│   ├── screens/      # UI screens
│   ├── services/     # API and business logic
│   └── widgets/      # Reusable UI components
└── backend/
    ├── src/
    │   ├── models/   # Database schemas
    │   ├── routes/   # API routes
    │   └── middleware/ # Auth middleware
    └── server.js     # Entry point
```

## 🔍 Features In Detail

### Location Tracking
- Driver locations update every 15 seconds
- Real-time map updates
- Different marker colors for current user vs. other drivers

### Authentication Flow
- Driver registration requires admin approval
- Admins can approve or reject driver applications
- Secure login with mobile number and password

### User Flow
- Select role (User/Driver/Admin)
- Users can immediately view the map
- Drivers need to register and get approved
- Admin need the Admin PIN and view their dashboard

## 👥 Contributors

- Pallapalli Sai Mourya - Frontend & Backend Development
- Mirthipati Chinni Krishna Balaji - UI/UX Design & Backend Development
- Lingampally Harshith Reddy - Frontend Development

---

Made with ❤️ using Flutter and Node.js
