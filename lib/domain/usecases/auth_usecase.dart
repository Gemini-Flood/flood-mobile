import 'package:first_ai/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future launchLogin(Map<String, String> body) async {
    return await _authRepository.login(body);
  }

  Future launchRegister(Map<String, String> body) async {
    return await _authRepository.register(body);
  }

  Future launchUpdateFCMToken(Map<String, String> body) async {
    return await _authRepository.updateFCMToken(body);
  }

  Future launchLogout() async {
    return await _authRepository.logout();
  }

}