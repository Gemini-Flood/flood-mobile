import 'package:first_ai/domain/entities/forecasts/rain.dart';

class RainModel extends Rain {

  RainModel({
    required super.threeH,
  });

  factory RainModel.fromJson(Map<String, dynamic> json) {
    return RainModel(
      threeH: json['3h'].toDouble(),
    );
  }
}