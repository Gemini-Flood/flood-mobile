import 'package:first_ai/domain/entities/floods/zone.dart';

class ZoneModel extends Zone {

  ZoneModel({
    required super.id,
    required super.location,
    required super.latitude,
    required super.longitude,
    required super.riskLevel,
    required super.historicalData,
    required super.createdAt
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
        id: json['id'],
        location: json['location'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        riskLevel: json['risk_level'],
        historicalData: json['historical_data'],
        createdAt: DateTime.parse(json['created_at'])
    );
  }
}