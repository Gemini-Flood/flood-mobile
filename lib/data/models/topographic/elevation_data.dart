import 'package:first_ai/data/models/topographic/location.dart';
import 'package:first_ai/domain/entities/topographic/elevation_data.dart';

class ElevationDataModel extends ElevationData {

  ElevationDataModel({
    required super.dataset,
    required super.elevation,
    required super.location
  });

  factory ElevationDataModel.fromJson(Map<String, dynamic> json) {
    return ElevationDataModel(
      dataset: json['dataset'],
      elevation: json['elevation'],
      location: LocationModel.fromJson(json['location']),
    );
  }
}
