import 'package:first_ai/domain/entities/forecasts/clouds.dart';

class CloudModel extends Clouds {

  CloudModel({
    required super.all,
  });

  factory CloudModel.fromJson(Map<String, dynamic> json) {
    return CloudModel(
      all: json['all'],
    );
  }
}