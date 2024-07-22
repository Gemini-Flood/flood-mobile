import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  Future<Map<String, dynamic>> loadJson() async {
    String jsonString = await rootBundle.loadString("assets/jsons/guide.json");
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  updateBtnState(bool isActive) {
    isActive = !isActive;
    return isActive;
  }

  showMsgBox(String msg, bool error, BuildContext context) {
    var bar = SnackBar(
      backgroundColor: error ? Colors.red.shade300 : Colors.green.shade300,
      content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Cabin",
          )
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  getDateType() {
    late bool isDay = false;
    TimeOfDay time = TimeOfDay.now();

    if(time.hour > 5 && time.hour < 18) {
      isDay = true;
    } else {
      isDay = false;
    }

    return isDay;
  }

  getBackground(String state) async {
    bool isDay = await getDateType();
    switch (state) {
      case "Clouds":
        return isDay ? "assets/images/cloudy_day.png" : "assets/images/cloudy_night.png";
      case "Clear":
        return isDay ? "assets/images/sunny_day.png" : "assets/images/sunny_night.png";
      case "Rain":
        return isDay ? "assets/images/rainy_day.png" : "assets/images/rainy_night.png";
      case "Drizzle":
        return isDay ? "assets/images/drizzle_day.png" : "assets/images/drizzle_day.png";
      case "Thunderstorm":
        return isDay ? "assets/images/stormy_day.png" : "assets/images/stormy_night.png";
      default:
        return isDay ? "assets/images/windy_day.png" : "assets/images/windy_night.png";
    }
  }
}