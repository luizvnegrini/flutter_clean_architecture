abstract class ISplashScreenPresenter {
  Stream<String> get navigateToStream;
  Future<void> checkAccount();
}
