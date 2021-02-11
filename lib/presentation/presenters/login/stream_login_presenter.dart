import 'dart:async';
import 'package:meta/meta.dart';

import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../presentation/presenters/login/login_state.dart';
import '../../../ui/pages/pages.dart';
import '../../../utils/extensions/extensions.dart';
import '../../protocols/protocols.dart';

class StreamLoginPresenter implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;
  var _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  @override
  Stream<String> get emailErrorStream => _controller?.stream?.map((state) => state.emailError)?.distinct();
  @override
  Stream<String> get passwordErrorStream => _controller?.stream?.map((state) => state.passwordError)?.distinct();
  @override
  Stream<String> get mainErrorStream => _controller?.stream?.map((state) => state.mainError)?.distinct();
  @override
  Stream<bool> get isFormValidStream => _controller?.stream?.map((state) => state.isFormValid)?.distinct();
  @override
  Stream<bool> get isLoadingStream => _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter({@required this.validation, @required this.authentication, @required this.saveCurrentAccount});

  void _update() => _controller?.add(_state);

  @override
  Future<void> auth() async {
    try {
      _state.isLoading = true;
      _update();
      final account = await authentication.auth(AuthenticationParams(email: _state.email, secret: _state.password));
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      _state.mainError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  @override
  void validateEmail(String email) {
    _state
      ..email = email
      ..emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  @override
  void validatePassword(String password) {
    _state
      ..password = password
      ..passwordError = validation.validate(field: 'password', value: password);
    _update();
  }

  @override
  void dispose() {
    _controller.close();
    _controller = null;
  }
}
