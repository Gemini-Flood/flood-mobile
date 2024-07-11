abstract class AuthDataSource {
  Future login(Map<String, String> body);

  Future signup(Map<String, String> body);

  Future updateFCMToken(Map<String, String> body);

  Future logOut();
}