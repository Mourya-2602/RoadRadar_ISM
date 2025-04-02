import 'package:flutter/material.dart';

// Auth Screens
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

// User Screens
import '../screens/user/user_home_screen.dart';
import '../screens/user/user_map_screen.dart';

// Driver Screens
import '../screens/driver/driver_home_screen.dart';
import '../screens/driver/driver_map_screen.dart';
import '../screens/driver/driver_profile_screen.dart';

// Admin Screens
import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/admin_map_screen.dart';
import '../screens/admin/drivers_list_screen.dart';
import '../screens/admin/pending_requests_screen.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';

  // User routes
  static const String userHome = '/user/home';
  static const String userMap = '/user/map';

  // Driver routes
  static const String driverHome = '/driver/home';
  static const String driverMap = '/driver/map';
  static const String driverProfile = '/driver/profile';

  // Admin routes
  static const String adminHome = '/admin/home';
  static const String adminMap = '/admin/map';
  static const String driversList = '/admin/drivers';
  static const String pendingRequests = '/admin/pending';

  // Route map
  static Map<String, WidgetBuilder> get routes {
    return {
      // Auth routes
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),

      // User routes
      userHome: (context) => const UserHomeScreen(),
      userMap: (context) => const UserMapScreen(),

      // Driver routes
      driverHome: (context) => const DriverHomeScreen(),
      driverMap: (context) => const DriverMapScreen(),
      driverProfile: (context) => const DriverProfileScreen(),

      // Admin routes
      adminHome: (context) => const AdminHomeScreen(),
      adminMap: (context) => const AdminMapScreen(),
      driversList: (context) => const DriversListScreen(),
      pendingRequests: (context) => const PendingRequestsScreen(),
    };
  }

  // Generate routes with parameters
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Here you can handle routes with parameters
    // For example, accessing a specific driver detail page

    if (settings.name?.startsWith('/driver/details/') ?? false) {
      // Extract driver ID from route
      final driverId = settings.name!.split('/').last;

      // Return driver details route
      // return MaterialPageRoute(
      //   builder: (context) => DriverDetailScreen(driverId: driverId),
      // );
    }

    // Return null to let the routes map handle known routes
    return null;
  }
}
