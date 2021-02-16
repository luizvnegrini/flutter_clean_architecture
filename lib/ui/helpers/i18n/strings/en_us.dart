import './translations.dart';

class EnUs implements Translations {
  @override
  String get addAccount => 'Create account';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get enter => 'Enter';
  @override
  String get name => 'Name';
  @override
  String get confirmPassword => 'Confirm password';
  @override
  String get login => 'Login';
  @override
  String get signUp => 'Sign up';
  @override
  String get wait => 'Wait...';
  @override
  String get msgInvalidField => 'Invalid field.';
  @override
  String get msgRequiredField => 'Required field.';
  @override
  String get msgInvalidCredentials => 'Invalid credentials.';
  @override
  String get msgUnexpectedError => 'Something went wrong. Please try again soon.';
  @override
  String get msgEmailInUse => 'This email is in use.';
}
