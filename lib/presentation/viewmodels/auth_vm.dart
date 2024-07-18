import 'package:first_ai/data/helpers/notifications.dart';
import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/domain/repositories/auth_repository.dart';
import 'package:first_ai/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {

  AuthRepository authRepository;

  AuthViewModel({required this.authRepository}) {
    updateFCM();
  }

  bool _loading = false;
  bool _error = false;

  bool get loading => _loading;
  bool get error => _error;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setError(bool value) {
    _error = value;
    notifyListeners();
  }

  updateFCM() async {
    setLoading(true);
    var token = await Notifications().getFCMToken();
    await Preferences().getUserInfos().then((value) async {
      if(value['id'] != null) {
        Map<String, String> body = {
          "id": value['id'],
          "token": token
        };
        await AuthUseCase(authRepository).launchUpdateFCMToken(body).then((value) async {
          if(value['code'] == 200) {
            setError(false);
            setLoading(false);
          } else if(value['error'] == true) {
            setError(true);
            setLoading(false);
          }
        });
      }
    });
  }

}