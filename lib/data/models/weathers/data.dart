import 'package:first_ai/data/models/weathers/coordinate.dart';
import 'package:first_ai/data/models/weathers/weather.dart';
import 'package:first_ai/data/models/weathers/principal.dart';
import 'package:first_ai/data/models/weathers/wind.dart';
import 'package:first_ai/data/models/weathers/clouds.dart';
import 'package:first_ai/data/models/weathers/sys.dart';
import 'package:first_ai/domain/entities/weathers/data.dart';

class WeatherDataModel extends WeatherData {

  WeatherDataModel({
    required super.coord,
    required super.weather,
    required super.base,
    required super.main,
    required super.visibility,
    required super.wind,
    required super.clouds,
    required super.dt,
    required super.sys,
    required super.timezone,
    required super.id,
    required super.name,
    required super.cod,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      coord: CoordModel.fromJson(json['coord']),
      weather: (json['weather'] as List).map((i) => WeatherModel.fromJson(i)).toList(),
      base: json['base'],
      main: PrincipalModel.fromJson(json['main']),
      visibility: json['visibility'],
      wind: WindModel.fromJson(json['wind']),
      clouds: CloudModel.fromJson(json['clouds']),
      dt: json['dt'],
      sys: SysModel.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }
}