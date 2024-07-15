import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/models/floods/report.dart';
import 'package:first_ai/data/models/floods/zone.dart';
import 'package:first_ai/domain/repositories/flood_repository.dart';
import 'package:first_ai/domain/usecases/flood_usecase.dart';
import 'package:flutter/material.dart';

class FloodViewModel extends ChangeNotifier {

  FloodRepository floodRepository;

  FloodViewModel({required this.floodRepository}) {
    setUpdate(false);
  }

  bool _error = false;
  bool _loading = false;
  bool _update = false;
  ReportModel? _report;
  ZoneModel? _zone;

  bool get error => _error;
  bool get loading => _loading;
  bool get update => _update;
  ReportModel get getReport => _report!;
  ZoneModel get getForecast => _zone!;

  setError(bool value) {
    _error = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setUpdate(bool value) {
    _update = value;
    notifyListeners();
  }

  setReport(ReportModel value) {
    _report = value;
    notifyListeners();
  }

  setZone(ZoneModel value) {
    _zone = value;
    notifyListeners();
  }

  saveZone(Map<String, dynamic> body, BuildContext context) async {
    setLoading(true);
    await FloodUseCase(floodRepository).actualizeZone(body).then((value) async {
      if(value['code'] == 200){
        setError(false);
        setLoading(false);
        setUpdate(true);
        Utils().showMsgBox(value['message'], false, context);
      }else if(value['error'] == true){
        setError(true);
        setLoading(false);
        setUpdate(false);
        Utils().showMsgBox(value['message'], true, context);
      }
    });
  }

  saveReport(Map<String, String> body, String filepath, BuildContext context) async {
    setLoading(true);
    await FloodUseCase(floodRepository).saveReport(body, filepath).then((value) async {
      if(value['code'] == 200){
        setError(false);
        setLoading(false);
        Utils().showMsgBox(value['message'], false, context);
      }else if(value['error'] == true){
        setError(true);
        setLoading(false);
        Utils().showMsgBox(value['message'], true, context);
      }
    });
  }
}