class LoginState {
  String emailError;
  String passwordError;
  String email;
  String password;

  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}
