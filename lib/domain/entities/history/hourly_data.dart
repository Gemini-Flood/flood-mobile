class HourlyData {
  late List<String> time;
  late List precipitation;
  late List rain;
  late List soilTemperature0To7cm;
  late List soilTemperature7To28cm;
  late List soilTemperature28To100cm;
  late List soilTemperature100To255cm;
  late List soilMoisture0To7cm;
  late List soilMoisture7To28cm;
  late List soilMoisture28To100cm;
  late List soilMoisture100To255cm;

  HourlyData({
    required this.time,
    required this.precipitation,
    required this.rain,
    required this.soilTemperature0To7cm,
    required this.soilTemperature7To28cm,
    required this.soilTemperature28To100cm,
    required this.soilTemperature100To255cm,
    required this.soilMoisture0To7cm,
    required this.soilMoisture7To28cm,
    required this.soilMoisture28To100cm,
    required this.soilMoisture100To255cm,
  });
}
