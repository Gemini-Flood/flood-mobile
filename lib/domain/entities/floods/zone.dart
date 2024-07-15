class Zone {
  final int id;
  final String location, latitude, longitude, riskLevel, historicalData;
  final DateTime createdAt;

  Zone({
    required this.id,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.riskLevel,
    required this.historicalData,
    required this.createdAt
  });
}