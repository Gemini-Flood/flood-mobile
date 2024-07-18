abstract class AlertDataSource {
  Future getAlerts();

  Future launchAlert(String id);
}