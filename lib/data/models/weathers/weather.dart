import 'package:first_ai/domain/entities/weathers/weather.dart';

class WeatherModel extends Weather {

  WeatherModel({required super.id, required super.main, required super.description, required super.icon});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}