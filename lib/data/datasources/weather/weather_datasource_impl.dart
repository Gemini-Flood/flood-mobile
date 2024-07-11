import 'dart:convert';
import 'package:first_ai/data/constants.dart';
import 'package:first_ai/data/datasources/weather/weather_datasource.dart';
import 'package:http/http.dart' as http;

class WeatherDataSourceImpl implements WeatherDataSource {

  @override
  Future getWeatherInfos(Map<String, dynamic> body) async {
    try{
      String url = "${Constants.baseUrl}weathers/prevision";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      http.Response request = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
      var response = json.decode(request.body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

}