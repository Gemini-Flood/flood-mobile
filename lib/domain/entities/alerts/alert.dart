import 'package:first_ai/domain/entities/floods/zone.dart';

class Alert {
  final int id;
  final int floodZoneId;
  final String title;
  final String message;
  final String riskLevel;
  final DateTime expiresAt;
  final DateTime createdAt;
  final Zone zone;

  Alert({
    required this.id,
    required this.floodZoneId,
    required this.title,
    required this.message,
    required this.riskLevel,
    required this.expiresAt,
    required this.createdAt,
    required this.zone,
  });
}