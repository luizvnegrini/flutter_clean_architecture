import 'package:meta/meta.dart';

class AuthenticationParams {
  final String email;
  final String secret;

  AuthenticationParams({
    @required this.email,
    @required this.secret,
  });
}
