import 'package:first_ai/data/datasources/authentication/auth_datasource_impl.dart';
import 'package:first_ai/domain/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>(create: (ref) {
  final authDataSourceImpl = AuthDataSourceImpl();
  return AuthRepositoryImpl(authDataSourceImpl: authDataSourceImpl);
});

class AuthRepositoryImpl extends AuthRepository{

  final AuthDataSourceImpl authDataSourceImpl;

  AuthRepositoryImpl({required this.authDataSourceImpl});

  @override
  Future login(Map<String, String> body) async {
    return await authDataSourceImpl.login(body);
  }

  @override
  Future logout() async {
    return await authDataSourceImpl.logOut();
  }

  @override
  Future register(Map<String, String> body) async {
    return await authDataSourceImpl.signup(body);
  }

  @override
  Future updateFCMToken(Map<String, String> body) async {
    return await authDataSourceImpl.updateFCMToken(body);
  }

}