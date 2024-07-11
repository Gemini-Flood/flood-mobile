import 'package:first_ai/domain/entities/weathers/wind.dart';

class WindModel extends Wind {

  WindModel({required super.speed, required super.deg});

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
    };
  }
}