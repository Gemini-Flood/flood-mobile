import 'package:first_ai/domain/entities/floods/report.dart';

class ReportModel extends Report {

  ReportModel({
    required super.id,
    required super.userId,
    required super.location,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.image,
    required super.createdAt
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      userId: json['user_id'],
      location: json['location'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: json['image'],
      createdAt: json['created_at']
    );
  }
}