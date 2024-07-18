import 'dart:convert';
import 'package:first_ai/data/constants.dart';
import 'package:first_ai/data/datasources/authentication/auth_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthDataSourceImpl implements AuthDataSource {

  @override
  Future login(Map<String, String> body) async {
    try {
      String url = "${Constants.baseUrl}auth/login";
      Map<String, String> headers = {
        "Accept": "application/json",
      };

      http.Response request = await http.post(Uri.parse(url), headers: headers, body: body);
      var response = json.decode(request.body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future signup(Map<String, String> body) async {
    try {
      String url = "${Constants.baseUrl}auth/register";
      Map<String, String> headers = {
        "Accept": "application/json",
      };

      http.Response request = await http.post(Uri.parse(url), headers: headers, body: body);
      var response = json.decode(request.body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future updateFCMToken(Map<String, String> body) async {
    try {
      String url = "${Constants.baseUrl}auth/updateToken";
      Map<String, String> headers = {
        "Accept": "application/json",
      };

      http.Response request = await http.post(Uri.parse(url), headers: headers, body: body);
      var response = json.decode(request.body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}