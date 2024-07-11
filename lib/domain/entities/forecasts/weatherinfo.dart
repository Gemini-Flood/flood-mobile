import 'package:first_ai/domain/entities/forecasts/clouds.dart';
import 'package:first_ai/domain/entities/forecasts/maininfo.dart';
import 'package:first_ai/domain/entities/forecasts/rain.dart';
import 'package:first_ai/domain/entities/forecasts/sys.dart';
import 'package:first_ai/domain/entities/forecasts/weather.dart';
import 'package:first_ai/domain/entities/forecasts/wind.dart';

class WeatherInfo {
  final int dt;
  final MainInfo main;
  final List<Weather> weather;
  final Clouds clouds;
  final Wind wind;
  final int visibility;
  final double pop;
  final Rain? rain;
  final Sys sys;
  final String dtTxt;

  WeatherInfo({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.visibility,
    required this.pop,
    required this.rain,
    required this.sys,
    required this.dtTxt,
  });
}