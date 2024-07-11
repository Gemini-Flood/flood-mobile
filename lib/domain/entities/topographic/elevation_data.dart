import 'package:first_ai/domain/entities/topographic/location.dart';

class ElevationData {
  final String dataset;
  final int elevation;
  final Location location;

  ElevationData({required this.dataset, required this.elevation, required this.location});
}
