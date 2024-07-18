import 'package:first_ai/data/datasources/alert/alert_datasource_impl.dart';
import 'package:first_ai/domain/repositories/alert_repository.dart';
import 'package:provider/provider.dart';

final alertRepositoryProvider = Provider<AlertRepositoryImpl>(create: (ref) {
  final alertDataSourceImpl = AlertDataSourceImpl();
  return AlertRepositoryImpl(alertDataSourceImpl: alertDataSourceImpl);
});

class AlertRepositoryImpl extends AlertRepository {

  final AlertDataSourceImpl alertDataSourceImpl;

  AlertRepositoryImpl({required this.alertDataSourceImpl});

  @override
  Future getAlerts() async {
    return await alertDataSourceImpl.getAlerts();
  }

  @override
  Future launchAlert(String id) async {
    return await alertDataSourceImpl.launchAlert(id);
  }
}