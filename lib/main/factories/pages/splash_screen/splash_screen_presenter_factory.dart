import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ISplashScreenPresenter makeGetxSplashScreenPresenter() => GetxSplashScreenPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
