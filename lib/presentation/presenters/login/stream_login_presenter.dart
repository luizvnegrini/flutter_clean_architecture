import 'dart:async';
import 'package:meta/meta.dart';

import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../utils/extensions/extensions.dart';
import '../../protocols/protocols.dart';

import 'login_state.dart';

class StreamLoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  var _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream => _controller?.stream?.map((state) => state.emailError)?.distinct();
  Stream<String> get passwordErrorStream => _controller?.stream?.map((state) => state.passwordError)?.distinct();
  Stream<String> get mainErrorStream => _controller?.stream?.map((state) => state.mainError)?.distinct();
  Stream<bool> get isFormValidStream => _controller?.stream?.map((state) => state.isFormValid)?.distinct();
  Stream<bool> get isLoadingStream => _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter({@required this.validation, @required this.authentication});

  void _update() => _controller?.add(_state);

  Future<void> auth() async {
    try {
      _state.isLoading = true;
      _update();
      await authentication.auth(AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

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
    _controller = null;
  }
}
