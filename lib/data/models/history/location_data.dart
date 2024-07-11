import 'package:first_ai/data/models/history/hourly_data.dart';
import 'package:first_ai/data/models/history/hourly_unit.dart';
import 'package:first_ai/domain/entities/history/location_data.dart';

class LocationDataModel extends LocationData {

  LocationDataModel({
    required super.latitude,
    required super.longitude,
    required super.generationTimeMs,
    required super.utcOffsetSeconds,
    required super.timezone,
    required super.timezoneAbbreviation,
    required super.elevation,
    required super.hourlyUnits,
    required super.hourly,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      generationTimeMs: json['generationtime_ms'],
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      elevation: json['elevation'],
      hourlyUnits: HourlyUnitModel.fromJson(json['hourly_units']),
      hourly: HourlyDataModel.fromJson(json['hourly']),
    );
  }
}
