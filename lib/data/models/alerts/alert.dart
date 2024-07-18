import 'package:first_ai/data/models/floods/zone.dart';
import 'package:first_ai/domain/entities/alerts/alert.dart';

class AlertModel extends Alert {

  AlertModel({
    required super.id,
    required super.floodZoneId,
    required super.title,
    required super.message,
    required super.riskLevel,
    required super.expiresAt,
    required super.createdAt,
    required super.zone
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      floodZoneId: json['flood_zone_id'],
      title: json['title'],
      message: json['message'],
      riskLevel: json['risk_level'],
      expiresAt: DateTime.parse(json['expires_at']),
      createdAt: DateTime.parse(json['created_at']),
      zone: ZoneModel.fromJson(json['zone']),
    );
  }

}