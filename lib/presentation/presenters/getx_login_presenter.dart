import 'package:get/state_manager.dart';
import 'package:home_automation/presentation/mixins/form_validation_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/enums/enums.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController
    with FormValidationManager, MainErrorManager, NavigationManager, LoadingManager
    implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  final _emailErrorObserver = Rx<UIError>();
  final _passwordErrorObserver = Rx<UIError>();

  @override
  Stream<UIError> get emailErrorStream => _emailErrorObserver.stream;
  @override
  Stream<UIError> get passwordErrorStream => _passwordErrorObserver.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  @override
  Future<void> auth() async {
    try {
      mainError = null;

      isLoading = true;
      final account = await authentication.auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);

      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;

        case DomainError.unexpected:
          mainError = UIError.unexpected;
          break;

        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
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
    isFormValid = _emailErrorObserver.value == null && _passwordErrorObserver.value == null && _email != null && _password != null;
  }

  @override
  void goToSignUp() {
    navigateTo = '/signup';
  }
}
