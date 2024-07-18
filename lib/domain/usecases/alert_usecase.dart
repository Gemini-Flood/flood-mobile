import 'package:first_ai/domain/repositories/alert_repository.dart';

class AlertUseCase {

  final AlertRepository _alertRepository;

  AlertUseCase(this._alertRepository);

  Future getAlerts() async {
    return await _alertRepository.getAlerts();
  }

  Future launchAlert(String id) async {
    return await _alertRepository.launchAlert(id);
  }
}