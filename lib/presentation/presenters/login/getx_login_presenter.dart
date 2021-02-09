import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';
import '../../../utils/extensions/extensions.dart';
import '../../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;

  String _email;
  String _password;
  final _emailErrorObserver = RxString();
  final _passwordErrorObserver = RxString();
  final _mainErrorObserver = RxString();
  final _isFormValidObserver = false.obs;
  final _isLoadingObserver = false.obs;

  @override
  Stream<String> get emailErrorStream => _emailErrorObserver.stream;
  @override
  Stream<String> get passwordErrorStream => _passwordErrorObserver.stream;
  @override
  Stream<String> get mainErrorStream => _mainErrorObserver.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValidObserver.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoadingObserver.stream;

  GetxLoginPresenter({@required this.validation, @required this.authentication});

  @override
  Future<void> auth() async {
    try {
      _isLoadingObserver.value = true;
      await authentication.auth(AuthenticationParams(email: _email, secret: _password));
    } on DomainError catch (error) {
      _mainErrorObserver.value = error.description;
    } finally {
      _isLoadingObserver.value = false;
    }
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailErrorObserver.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordErrorObserver.value = validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValidObserver.value = _emailErrorObserver.value == null && _passwordErrorObserver.value == null && _email != null && _password != null;
  }

  @override
  void dispose();
}
