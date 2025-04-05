import 'package:flutter/material.dart';

// Screens
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/user/user_home_screen.dart';
import '../screens/driver/driver_home_screen.dart';
import '../screens/driver/driver_profile_screen.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/drivers_list_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String userHome = '/user/home';
  static const String driverHome = '/driver/home';
  static const String driverProfile = '/driver/profile';
  static const String adminHome = '/admin/home';
  static const String adminDriversList = '/admin/drivers';
  static const String adminPendingRequests = '/admin/pending';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      roleSelection: (context) => const OnboardingScreen.roleSelection(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      userHome: (context) => const UserHomeScreen(),
      driverHome: (context) => const DriverHomeScreen(),
      driverProfile: (context) => const DriverProfileScreen(),
      adminHome: (context) => const AdminHomeScreen(),
      adminDriversList: (context) => const DriversListScreen(),
    };
  }
}
