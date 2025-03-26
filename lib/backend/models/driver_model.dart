class Driver {
  String? id;
  String registrationNumber;
  String mobileNumber;
  String name;
  String vehicleType;
  DateTime joinedDate;
  int speedLimitWarnings;

  Driver({
    this.id,
    required this.registrationNumber,
    required this.mobileNumber,
    required this.name,
    required this.vehicleType,
    required this.joinedDate,
    this.speedLimitWarnings = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'registrationNumber': registrationNumber,
      'mobileNumber': mobileNumber,
      'name': name,
      'vehicleType': vehicleType,
      'joinedDate': joinedDate.toIso8601String(),
      'speedLimitWarnings': speedLimitWarnings,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['_id']?.toString(),
      registrationNumber: map['registrationNumber'],
      mobileNumber: map['mobileNumber'],
      name: map['name'],
      vehicleType: map['vehicleType'],
      joinedDate: DateTime.parse(map['joinedDate']),
      speedLimitWarnings: map['speedLimitWarnings'] ?? 0,
    );
  }
}
