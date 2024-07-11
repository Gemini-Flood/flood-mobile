import 'package:first_ai/data/datasources/weather/weather_datasource_impl.dart';
import 'package:first_ai/domain/repositories/weather_repository.dart';
import 'package:provider/provider.dart';

final weatherRepositoryProvider = Provider<WeatherRepositoryImpl>(create: (ref) {
  final weatherDataSourceImpl = WeatherDataSourceImpl();
  return WeatherRepositoryImpl(weatherDataSourceImpl: weatherDataSourceImpl);
});

class WeatherRepositoryImpl extends WeatherRepository {

  final WeatherDataSourceImpl weatherDataSourceImpl;

  WeatherRepositoryImpl({required this.weatherDataSourceImpl});

  @override
  Future getWeatherInfos(Map<String, String> body) async {
    return await weatherDataSourceImpl.getWeatherInfos(body);
  }
}