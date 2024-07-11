import 'package:first_ai/domain/entities/forecasts/coord.dart';

class CoordModel extends Coord {

  CoordModel({
    required super.lat,
    required super.lon,
  });

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
    );
  }
}