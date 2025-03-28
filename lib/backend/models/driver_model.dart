class DriverModel {
  String? id;
  String registrationNumber;
  String mobileNumber;
  String name;
  String vehicleType;
  String driverpin;
  DateTime joinedDate;
  int speedLimitWarnings;

  DriverModel({
    this.id,
    required this.registrationNumber,
    required this.mobileNumber,
    required this.name,
    required this.vehicleType,
    required this.driverpin,
    required this.joinedDate,
    this.speedLimitWarnings=0,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'registrationNumber': registrationNumber,
      'mobileNumber': mobileNumber,
      'name': name,
      'vehicleType': vehicleType,
      'driverpin': driverpin,
      'joinedDate': joinedDate.toIso8601String(),
      'speedLimitWarnings': speedLimitWarnings,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['_id']?.toString(),
      registrationNumber: map['registrationNumber'],
      mobileNumber: map['mobileNumber'],
      name: map['name'],
      vehicleType: map['vehicleType'],
        driverpin: map['driverpin'],
      joinedDate: DateTime.parse(map['joinedDate']),
      speedLimitWarnings: map['speedLimitWarnings'] ?? 0,
    );
  }
}

