abstract class AlertRepository {
  Future getAlerts();

  Future launchAlert(String id);
}