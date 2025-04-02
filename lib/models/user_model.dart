class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    this.profileImageUrl,
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
      'mobileNumber': mobileNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create model from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  // Create a copy of the model with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}
