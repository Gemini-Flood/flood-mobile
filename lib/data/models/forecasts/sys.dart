import 'package:first_ai/domain/entities/forecasts/sys.dart';

class SysModel extends Sys {

  SysModel({
    required super.pod,
  });

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      pod: json['pod'],
    );
  }
}