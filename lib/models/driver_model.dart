import 'package:latlong2/latlong.dart';

class DriverModel {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final String vehicleNumber;
  final String? profileImageUrl;
  final DriverStatus status;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;
  final bool isLocationSharing;
  final LatLng? currentLocation;
  final VehicleDetails vehicleDetails;
  final Documents documents;

  DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.vehicleNumber,
    this.profileImageUrl,
    required this.status,
    required this.createdAt,
    required this.lastLogin,
    required this.isActive,
    required this.isLocationSharing,
    this.currentLocation,
    required this.vehicleDetails,
    required this.documents,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'vehicleNumber': vehicleNumber,
      'profileImageUrl': profileImageUrl,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isActive': isActive,
      'isLocationSharing': isLocationSharing,
      'currentLocation': currentLocation != null
          ? {
              'latitude': currentLocation!.latitude,
              'longitude': currentLocation!.longitude,
            }
          : null,
      'vehicleDetails': vehicleDetails.toJson(),
      'documents': documents.toJson(),
    };
  }

  // Create model from JSON
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      status: _getStatusFromString(json['status'] ?? 'pending'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      isLocationSharing: json['isLocationSharing'] ?? false,
      currentLocation: json['currentLocation'] != null
          ? LatLng(
              json['currentLocation']['latitude'],
              json['currentLocation']['longitude'],
            )
          : null,
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetails.fromJson(json['vehicleDetails'])
          : VehicleDetails.empty(),
      documents: json['documents'] != null
          ? Documents.fromJson(json['documents'])
          : Documents.empty(),
    );
  }

  // Helper method to get status enum from string
  static DriverStatus _getStatusFromString(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'approved':
        return DriverStatus.approved;
      case 'rejected':
        return DriverStatus.rejected;
      case 'pending':
      default:
        return DriverStatus.pending;
    }
  }

  // Create a copy of the model with updated fields
  DriverModel copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNumber,
    String? vehicleNumber,
    String? profileImageUrl,
    DriverStatus? status,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    bool? isLocationSharing,
    LatLng? currentLocation,
    VehicleDetails? vehicleDetails,
    Documents? documents,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      isLocationSharing: isLocationSharing ?? this.isLocationSharing,
      currentLocation: currentLocation ?? this.currentLocation,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
      documents: documents ?? this.documents,
    );
  }
}

// Driver status enum
enum DriverStatus {
  pending,
  approved,
  rejected,
}

// Vehicle details model
class VehicleDetails {
  final String type;
  final String model;
  final int year;
  final String color;

  VehicleDetails({
    required this.type,
    required this.model,
    required this.year,
    required this.color,
  });

  // Create an empty vehicle details object
  factory VehicleDetails.empty() {
    return VehicleDetails(
      type: '',
      model: '',
      year: DateTime.now().year,
      color: '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'model': model,
      'year': year,
      'color': color,
    };
  }

  // Create from JSON
  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      type: json['type'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      color: json['color'] ?? '',
    );
  }

  // Create a copy with updated fields
  VehicleDetails copyWith({
    String? type,
    String? model,
    int? year,
    String? color,
  }) {
    return VehicleDetails(
      type: type ?? this.type,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
    );
  }
}

// Documents model for driver verification
class Documents {
  final String? license;
  final String? insurance;
  final String? vehicleRC;

  Documents({
    this.license,
    this.insurance,
    this.vehicleRC,
  });

  // Create an empty documents object
  factory Documents.empty() {
    return Documents();
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'license': license,
      'insurance': insurance,
      'vehicleRC': vehicleRC,
    };
  }

  // Create from JSON
  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      license: json['license'],
      insurance: json['insurance'],
      vehicleRC: json['vehicleRC'],
    );
  }

  // Create a copy with updated fields
  Documents copyWith({
    String? license,
    String? insurance,
    String? vehicleRC,
  }) {
    return Documents(
      license: license ?? this.license,
      insurance: insurance ?? this.insurance,
      vehicleRC: vehicleRC ?? this.vehicleRC,
    );
  }
}
