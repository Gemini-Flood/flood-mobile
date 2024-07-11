import 'package:first_ai/domain/entities/forecasts/wind.dart';

class WindModel extends Wind {

  WindModel({
    required super.speed,
    required super.deg,
    required super.gust,
  });

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
      gust: json['gust'].toDouble(),
    );
  }
}