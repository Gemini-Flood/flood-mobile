import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_ai/data/constants.dart';
import 'package:first_ai/data/datasources/alert/alert_datasource.dart';

class AlertDataSourceImpl implements AlertDataSource {
  @override
  Future getAlerts() async {
    try{
      String url = "${Constants.baseUrl}alerts/actives";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      http.Response request = await http.get(Uri.parse(url), headers: headers);
      var response = json.decode(request.body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future launchAlert(String id) async {
    try{
      String url = "${Constants.baseUrl}alerts/launch/$id";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      http.Response request = await http.get(Uri.parse(url), headers: headers);
      var response = json.decode(request.body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

}