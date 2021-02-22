import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/enums/enums.dart';

import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  final _emailErrorObserver = Rx<UIError>();
  final _passwordErrorObserver = Rx<UIError>();
  final _mainErrorObserver = Rx<UIError>();
  final _navigateToObserver = RxString();
  final _isFormValidObserver = false.obs;
  final _isLoadingObserver = false.obs;

  @override
  Stream<UIError> get emailErrorStream => _emailErrorObserver.stream;
  @override
  Stream<UIError> get passwordErrorStream => _passwordErrorObserver.stream;
  @override
  Stream<UIError> get mainErrorStream => _mainErrorObserver.stream;
  @override
  Stream<String> get navigateToStream => _navigateToObserver.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValidObserver.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoadingObserver.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  @override
  Future<void> auth() async {
    try {
      _mainErrorObserver.value = null;

      _isLoadingObserver.value = true;
      final account = await authentication.auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);

      _navigateToObserver.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainErrorObserver.value = UIError.invalidCredentials;
          break;

        case DomainError.unexpected:
          _mainErrorObserver.value = UIError.unexpected;
          break;

        default:
          _mainErrorObserver.value = UIError.unexpected;
      }
    } finally {
      _isLoadingObserver.value = false;
    }
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailErrorObserver.value = _validateField('email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordErrorObserver.value = _validateField('password');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };

    final error = validation.validate(field: field, input: formData);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
        break;

      case ValidationError.requiredField:
        return UIError.requiredField;
        break;

      default:
        return null;
    }
  }

  void _validateForm() {
    _isFormValidObserver.value = _emailErrorObserver.value == null && _passwordErrorObserver.value == null && _email != null && _password != null;
  }

  @override
  void goToSignUp() {
    _navigateToObserver.value = '/signup';
  }
}
