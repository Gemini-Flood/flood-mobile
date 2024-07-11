import 'package:first_ai/data/models/forecasts/coord.dart';
import 'package:first_ai/domain/entities/forecasts/city.dart';

class CityModel extends City {

  CityModel({
    required super.id,
    required super.name,
    required super.coord,
    required super.country,
    required super.population,
    required super.timezone,
    required super.sunrise,
    required super.sunset,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      coord: CoordModel.fromJson(json['coord']),
      country: json['country'],
      population: json['population'],
      timezone: json['timezone'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}