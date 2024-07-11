import 'package:first_ai/domain/entities/weathers/coordinate.dart';
import 'package:first_ai/domain/entities/weathers/weather.dart';
import 'package:first_ai/domain/entities/weathers/principal.dart';
import 'package:first_ai/domain/entities/weathers/wind.dart';
import 'package:first_ai/domain/entities/weathers/clouds.dart';
import 'package:first_ai/domain/entities/weathers/sys.dart';

class WeatherData {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Principal main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  WeatherData({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });
}