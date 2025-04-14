class Driver {
  final String? id;
  final String name;
  final String mobileNumber;
  final String vehicleNumber;
  final String vehicleType;
  final String status;
  final DateTime registeredAt;
  final DateTime? lastLogin;
  final bool isActive;
  final LocationPoint? location;

  Driver({
    this.id,
    required this.name,
    required this.mobileNumber,
    required this.vehicleNumber,
    required this.vehicleType,
    this.status = 'pending',
    DateTime? registeredAt,
    this.lastLogin,
    this.isActive = false,
    this.location,
  }) : this.registeredAt = registeredAt ?? DateTime.now();

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      vehicleNumber: json['vehicleNumber'],
      vehicleType: json['vehicleType'] ?? 'unknown',
      status: json['status'] ?? 'pending',
      registeredAt: json['registeredAt'] != null
          ? DateTime.parse(json['registeredAt'])
          : DateTime.now(),
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isActive: json['isActive'] ?? false,
      location: json['location'] != null
          ? LocationPoint.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'mobileNumber': mobileNumber,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'status': status,
      'isActive': isActive,
    };

    if (id != null) data['id'] = id;
    if (location != null) data['location'] = location!.toJson();

    return data;
  }

  Driver copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    String? vehicleNumber,
    String? vehicleType,
    String? status,
    DateTime? registeredAt,
    DateTime? lastLogin,
    bool? isActive,
    LocationPoint? location,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      location: location ?? this.location,
    );
  }
}

class LocationPoint {
  final String type;
  final List<double> coordinates;

  LocationPoint({
    this.type = 'Point',
    required this.coordinates,
  });

  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class VehicleDetails {
  final String type;
  final String model;
  final int? year;

  VehicleDetails({
    required this.type,
    required this.model,
    this.year,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      type: json['type'],
      model: json['model'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'model': model,
    };

    if (year != null) data['year'] = year;

    return data;
  }
}

class Documents {
  final String? license;
  final String? insurance;
  final String? vehicleRC;

  Documents({
    this.license,
    this.insurance,
    this.vehicleRC,
  });

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      license: json['license'],
      insurance: json['insurance'],
      vehicleRC: json['vehicleRC'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (license != null) data['license'] = license;
    if (insurance != null) data['insurance'] = insurance;
    if (vehicleRC != null) data['vehicleRC'] = vehicleRC;

    return data;
  }
}
