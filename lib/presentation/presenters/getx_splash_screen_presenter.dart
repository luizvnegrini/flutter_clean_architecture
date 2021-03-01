import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/pages/pages.dart';

class GetxSplashScreenPresenter with NavigationManager implements ISplashScreenPresenter {
  final ILoadCurrentAccount loadCurrentAccount;

  GetxSplashScreenPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));

    try {
      final account = await loadCurrentAccount.load();

      navigateTo = account?.token == null ? '/login' : '/surveys';
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
