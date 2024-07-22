import 'package:first_ai/data/models/history.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {

  ChatViewModel();

  bool _loading = false;
  bool _update = false;
  bool _current = false;
  List<HistoryModel> _histories = [];

  bool get loading => _loading;
  bool get update => _update;
  bool get current => _current;
  List<HistoryModel> get getHistories => _histories;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setUpdate(bool value) {
    _update = value;
    notifyListeners();
  }

  setCurrent(bool value) {
    _current = value;
    notifyListeners();
  }

  setHistories(List<HistoryModel> value) {
    _histories = value;
    notifyListeners();
  }

}