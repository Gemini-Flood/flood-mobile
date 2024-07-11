class HourlyUnits {
  late String time;
  late String precipitation;
  late String rain;
  late String soilTemperature0To7cm;
  late String soilTemperature7To28cm;
  late String soilTemperature28To100cm;
  late String soilTemperature100To255cm;
  late String soilMoisture0To7cm;
  late String soilMoisture7To28cm;
  late String soilMoisture28To100cm;
  late String soilMoisture100To255cm;

  HourlyUnits({
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
