import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const AddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  @override
  List get props => [name, email, password, passwordConfirmation];
}
