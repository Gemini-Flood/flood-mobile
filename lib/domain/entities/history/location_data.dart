import 'package:first_ai/domain/entities/history/hourly_data.dart';
import 'package:first_ai/domain/entities/history/hourly_unit.dart';

class LocationData {
  late double latitude;
  late double longitude;
  late double generationTimeMs;
  late int utcOffsetSeconds;
  late String timezone;
  late String timezoneAbbreviation;
  late int elevation;
  late HourlyUnits hourlyUnits;
  late HourlyData hourly;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.generationTimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
  });
}
