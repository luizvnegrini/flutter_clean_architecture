import 'package:get/state_manager.dart';
import 'package:home_automation/ui/pages/signup/signup.dart';
import 'package:meta/meta.dart';

import '../../presentation/enums/enums.dart';

import '../../ui/helpers/errors/ui_error.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements ISignUpPresenter {
  final IValidation validation;

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;
  final _nameErrorObserver = Rx<UIError>();
  final _emailErrorObserver = Rx<UIError>();
  final _passwordErrorObserver = Rx<UIError>();
  final _passwordConfirmationErrorObserver = Rx<UIError>();
  final _isFormValidObserver = RxBool();

  @override
  Stream<UIError> get nameErrorStream => _nameErrorObserver.stream;
  @override
  Stream<UIError> get emailErrorStream => _emailErrorObserver.stream;
  @override
  Stream<UIError> get passwordErrorStream => _passwordErrorObserver.stream;
  @override
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationErrorObserver.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValidObserver.stream;

  GetxSignUpPresenter({@required this.validation});

  @override
  Future<void> add() async {}

  @override
  void validateName(String name) {
    _name = name;
    _nameErrorObserver.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailErrorObserver.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordErrorObserver.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationErrorObserver.value = _validateField(field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

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
  void dispose();
}
