import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences infos;

  saveWeatherInfos(var weather, forecast, locate, elevation) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("weather", json.encode(weather));
    preferences.setString("forecast", json.encode(forecast));
    preferences.setString("locate", json.encode(locate));
    preferences.setString("elevation", json.encode(elevation));
  }

  getWeatherInfos() async{
    var datas = null;
    infos = await SharedPreferences.getInstance();
    datas = {
      "weather": infos.get("weather"),
      "forecast": infos.get("forecast"),
      "locate": infos.get("locate"),
      "elevation": infos.get("elevation"),
    };
    return datas;
  }

  saveUserInfos(var id, name, email)  async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", id.toString());
    preferences.setString("name", name.toString());
    preferences.setString("email", email.toString());
  }

  getUserInfos() async{
    var datas = null;
    infos = await SharedPreferences.getInstance();
    datas = {
      "id": infos.get("id"),
      "name": infos.get("name"),
      "email": infos.get("email")
    };
    return datas;
  }
}