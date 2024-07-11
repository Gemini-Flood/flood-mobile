import 'package:first_ai/domain/entities/weathers/sys.dart';

class SysModel extends Sys {

  SysModel({required super.country, required super.sunrise, required super.sunset});

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}