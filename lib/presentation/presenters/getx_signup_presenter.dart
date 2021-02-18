import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/enums/enums.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/signup/signup.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements ISignUpPresenter {
  final IValidation validation;
  final IAddAccount addAccount;
  final ISaveCurrentAccount saveCurrentAccount;

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  final _nameErrorObserver = Rx<UIError>();
  final _emailErrorObserver = Rx<UIError>();
  final _passwordErrorObserver = Rx<UIError>();
  final _passwordConfirmationErrorObserver = Rx<UIError>();
  final _mainErrorObserver = Rx<UIError>();
  final _navigateToObserver = RxString();
  final _isFormValidObserver = false.obs;
  final _isLoadingObserver = false.obs;

  @override
  Stream<UIError> get nameErrorStream => _nameErrorObserver.stream;
  @override
  Stream<UIError> get emailErrorStream => _emailErrorObserver.stream;
  @override
  Stream<UIError> get passwordErrorStream => _passwordErrorObserver.stream;
  @override
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationErrorObserver.stream;
  @override
  Stream<UIError> get mainErrorStream => _mainErrorObserver.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValidObserver.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoadingObserver.stream;
  @override
  Stream<String> get navigateToStream => _navigateToObserver.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  @override
  Future<void> signUp() async {
    try {
      _mainErrorObserver.value = null;

      _isLoadingObserver.value = true;
      final account = await addAccount.add(AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ));

      await saveCurrentAccount.save(account);

      _navigateToObserver.value = '/home';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainErrorObserver.value = UIError.emailInUse;
          break;

        case DomainError.unexpected:
          _mainErrorObserver.value = UIError.unexpected;
          break;

        default:
          _mainErrorObserver.value = UIError.unexpected;
          break;
      }
    } finally {
      _isLoadingObserver.value = false;
    }
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameErrorObserver.value = _validateField('name');
    _validateForm();
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

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationErrorObserver.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
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
    _isFormValidObserver.value = _nameErrorObserver.value == null &&
        _emailErrorObserver.value == null &&
        _passwordErrorObserver.value == null &&
        _passwordConfirmationErrorObserver.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  @override
  void goToLogin() {
    _navigateToObserver.value = '/login';
  }
}
