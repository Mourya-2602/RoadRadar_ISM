class AdminModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final AdminRole role;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.role,
    required this.permissions,
    required this.createdAt,
    required this.lastLogin,
    required this.isActive,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'permissions': permissions,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create model from JSON
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      role: _getRoleFromString(json['role'] ?? 'admin'),
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  // Helper method to get role enum from string
  static AdminRole _getRoleFromString(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'super_admin':
        return AdminRole.superAdmin;
      case 'manager':
        return AdminRole.manager;
      case 'admin':
      default:
        return AdminRole.admin;
    }
  }

  // Create a copy of the model with updated fields
  AdminModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    AdminRole? role,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return AdminModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }

  // Check if admin has a specific permission
  bool hasPermission(String permission) {
    // Super admins have all permissions
    if (role == AdminRole.superAdmin) {
      return true;
    }

    return permissions.contains(permission);
  }
}

// Admin role enum
enum AdminRole {
  admin,
  superAdmin,
  manager,
}

// Admin permissions constants
class AdminPermissions {
  static const String viewDrivers = 'view_drivers';
  static const String approveDrivers = 'approve_drivers';
  static const String rejectDrivers = 'reject_drivers';
  static const String viewUsers = 'view_users';
  static const String manageUsers = 'manage_users';
  static const String viewMap = 'view_map';
  static const String manageSettings = 'manage_settings';
  static const String viewAnalytics = 'view_analytics';
  static const String manageAdmins = 'manage_admins';
}
