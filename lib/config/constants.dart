class AppConstants {
  // API Keys
  static const String mapApiKey = 'your_api_key';

  // App Info
  static const String appName = 'Road Radar';
  static const String appVersion = '1.0.0';

  // Admin PIN
  static const String adminPIN =
      '123456'; // Temporary - would be better stored in a secure location

  // Assets
  static const String logoPath = 'assets/images/logo.png';

  // Shared Preferences Keys
  static const String userTypeKey = 'user_type';
  static const String userNameKey = 'user_name';
  static const String driverIdKey = 'driver_id';
  static const String isLoggedInKey = 'is_logged_in';

  // User Types
  static const String userType = 'user';
  static const String driverType = 'driver';
  static const String adminType = 'admin';

  // Placeholder for Map
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
}
