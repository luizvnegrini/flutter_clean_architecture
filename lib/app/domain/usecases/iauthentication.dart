import '../entities/entities.dart';

abstract class IAuthentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams(
    this.email,
    this.password,
  );
}
