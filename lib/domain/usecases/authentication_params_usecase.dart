import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  const AuthenticationParams({
    @required this.email,
    @required this.secret,
  });

  @override
  List get props => [email, secret];
}
