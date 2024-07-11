import 'package:first_ai/domain/entities/forecasts/city.dart';
import 'package:first_ai/domain/entities/forecasts/weatherinfo.dart';

class Forecast {
  final String cod;
  final int message;
  final int cnt;
  final List<WeatherInfo> list;
  final City city;

  Forecast({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });
}
