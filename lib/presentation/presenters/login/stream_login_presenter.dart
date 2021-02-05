import 'dart:async';
import 'package:meta/meta.dart';

import '../../protocols/protocols.dart';

import 'login_state.dart';

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }

  void dispose() {
    _controller.close();
  }
}
