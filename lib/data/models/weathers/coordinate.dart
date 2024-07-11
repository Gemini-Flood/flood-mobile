import 'package:first_ai/domain/entities/weathers/coordinate.dart';

class CoordModel extends Coord {

  CoordModel({required super.lon, required super.lat});

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
    );
  }
}