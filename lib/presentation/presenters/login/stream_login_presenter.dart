import 'dart:async';
import 'package:meta/meta.dart';

import '../../protocols/protocols.dart';

import 'login_state.dart';

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({@required this.validation});

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state
      ..email = email
      ..emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state
      ..password = password
      ..passwordError = validation.validate(field: 'password', value: password);
    _update();
  }

  void dispose() {
    _controller.close();
  }
}
