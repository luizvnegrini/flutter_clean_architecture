abstract class ILoginPresenter {
  Stream get emailErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
