abstract class AuthRepository {

  Future login(Map<String, String> body);

  Future register(Map<String, String> body);

  Future updateFCMToken(Map<String, String> body);

  Future logout();
}