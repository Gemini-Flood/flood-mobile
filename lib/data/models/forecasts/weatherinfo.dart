import 'package:first_ai/data/models/forecasts/clouds.dart';
import 'package:first_ai/data/models/forecasts/maininfo.dart';
import 'package:first_ai/data/models/forecasts/rain.dart';
import 'package:first_ai/data/models/forecasts/sys.dart';
import 'package:first_ai/data/models/forecasts/weather.dart';
import 'package:first_ai/data/models/forecasts/wind.dart';
import 'package:first_ai/domain/entities/forecasts/weatherinfo.dart';

class WeatherInfoModel extends WeatherInfo {

  WeatherInfoModel({
    required super.dt,
    required super.main,
    required super.weather,
    required super.clouds,
    required super.wind,
    required super.visibility,
    required super.pop,
    required super.rain,
    required super.sys,
    required super.dtTxt,
  });

  factory WeatherInfoModel.fromJson(Map<String, dynamic> json) {
    return WeatherInfoModel(
      dt: json['dt'],
      main: MainInfoModel.fromJson(json['main']),
      weather: (json['weather'] as List).map((i) => WeatherModel.fromJson(i)).toList(),
      clouds: CloudModel.fromJson(json['clouds']),
      wind: WindModel.fromJson(json['wind']),
      visibility: json['visibility'],
      pop: json['pop'].toDouble(),
      rain: json['rain'] != null ? RainModel.fromJson(json['rain']) : null,
      sys: SysModel.fromJson(json['sys']),
      dtTxt: json['dt_txt'],
    );
  }
}