import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/models/alerts/alert.dart';
import 'package:first_ai/domain/repositories/alert_repository.dart';
import 'package:first_ai/domain/usecases/alert_usecase.dart';
import 'package:flutter/material.dart';

class AlertViewModel extends ChangeNotifier {

  AlertRepository alertRepository;

  AlertViewModel({required this.alertRepository});

  bool _loading = false;
  bool _error = false;
  AlertModel? _alert;

  bool get loading => _loading;
  bool get error => _error;
  AlertModel get getAlert => _alert!;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setError(bool value) {
    _error = value;
    notifyListeners();
  }

  setAlert(AlertModel value) {
    _alert = value;
    notifyListeners();
  }

  getAlerts() async {
    setLoading(true);
    await AlertUseCase(alertRepository).getAlerts().then((value) {
      if(value['code'] == 200) {
        setAlert(AlertModel.fromJson(value['data']));
        setLoading(false);
      } else if(value['error'] == true) {
        setError(true);
        setLoading(false);
      }
    });
  }

  launchAlert(String id, BuildContext context) async {
    setLoading(true);
    await AlertUseCase(alertRepository).launchAlert(id).then((value) {
      if(value['code'] == 200) {
        Utils().showMsgBox(value['message'], false, context);
        setLoading(false);
      } else if(value['error'] == true) {
        Utils().showMsgBox(value['message'], false, context);
        setLoading(false);
      }
    });
  }
}