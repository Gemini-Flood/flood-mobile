import 'package:first_ai/domain/repositories/weather_repository.dart';

class WeatherUseCase {

  final WeatherRepository _weatherRepository;

  WeatherUseCase(this._weatherRepository);

  Future retrieveWeatherInfos(Map<String, String> body) async {
    return await _weatherRepository.getWeatherInfos(body);
  }

}