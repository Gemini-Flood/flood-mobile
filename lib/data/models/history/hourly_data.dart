import 'package:first_ai/domain/entities/history/hourly_data.dart';

class HourlyDataModel extends HourlyData {

  HourlyDataModel({
    required super.time,
    required super.precipitation,
    required super.rain,
    required super.soilTemperature0To7cm,
    required super.soilTemperature7To28cm,
    required super.soilTemperature28To100cm,
    required super.soilTemperature100To255cm,
    required super.soilMoisture0To7cm,
    required super.soilMoisture7To28cm,
    required super.soilMoisture28To100cm,
    required super.soilMoisture100To255cm,
  });

  factory HourlyDataModel.fromJson(Map<String, dynamic> json) {
    return HourlyDataModel(
      time: List<String>.from(json['time']),
      precipitation: List.from(json['precipitation']),
      rain: List.from(json['rain']),
      soilTemperature0To7cm: List.from(json['soil_temperature_0_to_7cm']),
      soilTemperature7To28cm: List.from(json['soil_temperature_7_to_28cm']),
      soilTemperature28To100cm: List.from(json['soil_temperature_28_to_100cm']),
      soilTemperature100To255cm: List.from(json['soil_temperature_100_to_255cm']),
      soilMoisture0To7cm: List.from(json['soil_moisture_0_to_7cm']),
      soilMoisture7To28cm: List.from(json['soil_moisture_7_to_28cm']),
      soilMoisture28To100cm: List.from(json['soil_moisture_28_to_100cm']),
      soilMoisture100To255cm: List.from(json['soil_moisture_100_to_255cm']),
    );
  }
}
