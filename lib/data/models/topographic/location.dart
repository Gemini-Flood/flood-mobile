import 'package:first_ai/domain/entities/topographic/location.dart';

class LocationModel extends Location {

  LocationModel({
    required super.lat,
    required super.lng
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
