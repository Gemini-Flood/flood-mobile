import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/models/floods/report.dart';
import 'package:first_ai/data/models/floods/zone.dart';
import 'package:first_ai/domain/repositories/flood_repository.dart';
import 'package:first_ai/domain/usecases/flood_usecase.dart';
import 'package:first_ai/presentation/screens/home.dart';
import 'package:flutter/material.dart';

class FloodViewModel extends ChangeNotifier {

  FloodRepository floodRepository;

  FloodViewModel({required this.floodRepository}) {
    setUpdate(false);
    retrieveDatas();
  }

  bool _retrieving = false;
  bool _error = false;
  bool _loading = false;
  bool _update = false;
  ReportModel? _report;
  List<ReportModel> _reports = [];
  ZoneModel? _zone;
  List<ZoneModel> _zones = [];

  bool get retrieving => _retrieving;
  bool get error => _error;
  bool get loading => _loading;
  bool get update => _update;
  ReportModel get getReport => _report!;
  List<ReportModel> get getReports => _reports;
  ZoneModel get getForecast => _zone!;
  List<ZoneModel> get getZones => _zones;

  setRetrieving(bool value) {
    _retrieving = value;
    notifyListeners();
  }

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

  setReports(List value) {
    _reports = (value).map((i) => ReportModel.fromJson(i)).toList();
    notifyListeners();
  }

  setZone(ZoneModel value) {
    _zone = value;
    notifyListeners();
  }

  setZones(List value) {
    _zones = (value).map((i) => ZoneModel.fromJson(i)).toList();
    notifyListeners();
  }

  saveZone(Map<String, dynamic> body, var userInfos, BuildContext context) async {
    setLoading(true);
    await FloodUseCase(floodRepository).actualizeZone(body).then((value) async {
      if(value['code'] == 200){
        setError(false);
        setLoading(false);
        setUpdate(true);
        Utils().showMsgBox(value['message'], false, context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(userInfos: userInfos)), (route) => false);
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

  retrieveReport() async {
    await Preferences().getUserInfos().then((value) async {
      if(value['id'] != null) {
        await FloodUseCase(floodRepository).getUserReports(value['id']).then((value) async {
          if(value['code'] == 200) {
            setError(false);
            setReports(value['data']);
          } else if(value['error'] == true) {
            setError(true);
          }
        });
      }
    });
  }

  retrieveZone() async {
    await FloodUseCase(floodRepository).getZones().then((value) async {
      if(value['code'] == 200) {
        setError(false);
        setZones(value['data']);
      } else if(value['error'] == true) {
        setError(true);
      }
    });
  }

  retrieveDatas() async {
    setRetrieving(true);
    await retrieveReport();
    await retrieveZone();
    setRetrieving(false);
  }
}