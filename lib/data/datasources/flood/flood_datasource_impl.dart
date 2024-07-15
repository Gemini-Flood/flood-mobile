import 'dart:convert';

import 'package:first_ai/data/constants.dart';
import 'package:first_ai/data/datasources/flood/flood_datasource.dart';
import 'package:http/http.dart' as http;

class FloodDataSourceImpl implements FloodDataSource {
  @override
  Future getReports() async {
    try{
      String url = "${Constants.baseUrl}floods/reports";
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
  Future getUserReports(String id) async {
    try{
      String url = "${Constants.baseUrl}floods/reports/$id";
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
  Future saveReport(Map<String, String> body, String filepath) async {
    try{
      String url = "${Constants.baseUrl}floods/report";
      Map<String, String> headers = {
        'Content-Type': "multipart/form-data; charset=utf-8",
        'Accept': 'application/json',
      };

      var request = http.MultipartRequest('POST', Uri.parse(url))..fields.addAll(body)..headers.addAll(headers)..files.add(
          await http.MultipartFile.fromPath('photo', filepath)
      );
      var result = await http.Response.fromStream(await request.send());
      var response = json.decode(result.body);

      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future getZones() async {
    try{
      String url = "${Constants.baseUrl}floods/zones";
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
  Future actualizeZone(Map<String, dynamic> body) async {
    try{
      String url = "${Constants.baseUrl}floods/actualizeZones";
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