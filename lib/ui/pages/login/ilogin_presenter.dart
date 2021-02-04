abstract class ILoginPresenter {
  Stream get emailErrorStream;
  Stream get passwordErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
