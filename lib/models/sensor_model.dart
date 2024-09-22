class SensorModel {
  final String sensorId;
  final String location;
  final double batteryLevel;
  final double waterLevel;
  final String alertMessage;

  SensorModel({
    required this.sensorId,
    required this.location,
    required this.batteryLevel,
    required this.waterLevel,
    required this.alertMessage,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      sensorId: json['sensor_id'],
      location: json['location'],
      batteryLevel: json['battery_level'],
      waterLevel: json['water_level'],
      alertMessage: json['alert'],
    );
  }
}
