import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashScreenPresenter implements ISplashScreenPresenter {
  final ILoadCurrentAccount loadCurrentAccount;
  final _navigateToObserver = RxString();

  GetxSplashScreenPresenter({@required this.loadCurrentAccount});

  @override
  Stream<String> get navigateToStream => _navigateToObserver.stream;

  @override
  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();

      _navigateToObserver.value = account == null ? '/login' : '/home';
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      _navigateToObserver.value = '/login';
    }
  }
}
