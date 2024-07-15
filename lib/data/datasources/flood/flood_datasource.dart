abstract class FloodDataSource {
  Future getReports();

  Future getUserReports(String id);

  Future saveReport(Map<String, String> body, String filepath);

  Future getZones();

  Future actualizeZone(Map<String, dynamic> body);
}