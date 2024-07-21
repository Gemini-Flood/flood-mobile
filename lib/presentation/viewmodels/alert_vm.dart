import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/models/alerts/alert.dart';
import 'package:first_ai/domain/repositories/alert_repository.dart';
import 'package:first_ai/domain/usecases/alert_usecase.dart';
import 'package:flutter/material.dart';

class AlertViewModel extends ChangeNotifier {

  AlertRepository alertRepository;

  AlertViewModel({required this.alertRepository}){
    getAlerts();
  }

  bool _loading = false;
  bool _error = false;
  bool _request = false;
  AlertModel? _alert;
  List<AlertModel> _alerts = [];
  Map<int, bool> _expandedStates = {};

  bool get loading => _loading;
  bool get error => _error;
  bool get request => _request;
  AlertModel get alert => _alert!;
  List<AlertModel> get alerts => _alerts;
  Map<int, bool> get expandedStates => _expandedStates;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setError(bool value) {
    _error = value;
    notifyListeners();
  }

  setRequest(bool value) {
    _request = value;
    notifyListeners();
  }

  setAlert(AlertModel value) {
    _alert = value;
    notifyListeners();
  }

  setAlerts(List value) {
    _alerts = (value).map((e) => AlertModel.fromJson(e)).toList();
    notifyListeners();
  }

  setExpandedStates(Map<int, bool> value) {
    _expandedStates = value;
    notifyListeners();
  }

  updateExpandedStates(int id) {
    _expandedStates[id] = !_expandedStates[id]!;
    notifyListeners();
  }

  bool isExpanded(int id) {
    return _expandedStates[id] ?? false;
  }

  getAlerts() async {
    setLoading(true);
    await AlertUseCase(alertRepository).getAlerts().then((value) async {
      if(value['code'] == 200)  {
        await setAlerts(value['data']);
        var expandedStates = Map<int, bool>.fromIterable(
            _alerts,
            key: (alert) => alert.id,
            value: (_) => false
        );
        await setExpandedStates(expandedStates);
        setLoading(false);
      } else if(value['error'] == true) {
        setError(true);
        setLoading(false);
      }
    });
  }

  launchAlert(String id, BuildContext context) async {
    setRequest(true);
    await AlertUseCase(alertRepository).launchAlert(id).then((value) {
      if(value['code'] == 200) {
        Utils().showMsgBox(value['message'], false, context);
        setRequest(false);
      } else if(value['error'] == true) {
        Utils().showMsgBox(value['message'], false, context);
        setRequest(false);
      }
    });
  }
}