import 'package:first_ai/data/helpers/permissions.dart';
import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/models/ai/gemini_prediction.dart';
import 'package:first_ai/data/models/forecasts/forecast.dart';
import 'package:first_ai/data/models/history/location_data.dart';
import 'package:first_ai/data/models/topographic/elevation_data.dart';
import 'package:first_ai/data/models/weathers/data.dart';
import 'package:first_ai/domain/repositories/weather_repository.dart';
import 'package:first_ai/domain/usecases/weather_usecase.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class WeatherViewModel extends ChangeNotifier {

  WeatherRepository weatherRepository;
  GoogleViewModel? googleViewModel;

  /*WeatherViewModel({required this.weatherRepository}) {
    retrieveWeatherDatas(update: false, position: null);
  }*/

  WeatherViewModel({required this.weatherRepository});

  bool _error = false;
  bool _loading = false;
  bool _update = false;
  String _errorMessage = "";
  String _background = "";

  WeatherDataModel? _weatherData;
  ForecastModel? _forecast;
  LocationDataModel? _locate;
  ElevationDataModel? _elevation;

  bool get error => _error;
  bool get loading => _loading;
  bool get update => _update;
  String get errorMessage => _errorMessage;
  String get getBackground => _background;
  GoogleViewModel get getGoogleViewModel => googleViewModel!;

  setGoogleViewModel(GoogleViewModel value) {
    googleViewModel = value;
    notifyListeners();
  }

  WeatherDataModel get getWeatherData => _weatherData!;
  ForecastModel get getForecast => _forecast!;
  LocationDataModel get getLocate => _locate!;
  ElevationDataModel get getElevation => _elevation!;

  setError(bool value) {
    _error = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setUpdate(bool value) {
    _update = value;
    notifyListeners();
  }

  setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  setBackground(String value) {
    _background = value;
    notifyListeners();
  }

  setWeatherData(WeatherDataModel value) {
    _weatherData = value;
    notifyListeners();
  }

  setForecast(ForecastModel value) {
    _forecast = value;
    notifyListeners();
  }

  setLocate(LocationDataModel value) {
    _locate = value;
    notifyListeners();
  }

  setElevation(ElevationDataModel value) {
    _elevation = value;
    notifyListeners();
  }

  retrieveWeatherDatas({required bool update, required String latitude, required String longitude}) async {

    if(latitude != null && longitude != null){

      update ? setUpdate(true) : setLoading(true);

      Map<String, String> body = {
        "lat": latitude.toString(),
        "long": longitude.toString()
      };

      await WeatherUseCase(weatherRepository).retrieveWeatherInfos(body).then((value) async {
        if(value['code'] == 200){
          setError(false);
          setErrorMessage("");
          setWeatherData(WeatherDataModel.fromJson(value['data']['prediction']));
          setForecast(ForecastModel.fromJson(value['data']['forecast']));
          setLocate(LocationDataModel.fromJson(value['data']['history']));
          setElevation(ElevationDataModel.fromJson(value['data']['topography']));
          setBackground(await Utils().getBackground(getWeatherData.weather.first.main));
          await Preferences().saveWeatherInfos(value['data']['prediction'], value['data']['forecast'], value['data']['history'], value['data']['topography']);
        }else if(value['error'] == true){
          setError(true);
          setErrorMessage(value['message']);
        }
      });

      update ? setUpdate(false) : setLoading(false);

    }

  }
}