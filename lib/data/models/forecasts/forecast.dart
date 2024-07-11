import 'package:first_ai/data/models/forecasts/city.dart';
import 'package:first_ai/data/models/forecasts/weatherinfo.dart';
import 'package:first_ai/domain/entities/forecasts/forecast.dart';

class ForecastModel extends Forecast {

  ForecastModel({
    required super.cod,
    required super.message,
    required super.cnt,
    required super.list,
    required super.city,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      list: (json['list'] as List).map((i) => WeatherInfoModel.fromJson(i)).toList(),
      city: CityModel.fromJson(json['city']),
    );
  }
}
