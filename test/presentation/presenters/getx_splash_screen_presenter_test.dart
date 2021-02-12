import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:home_automation/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/entities/account_entity.dart';
import 'package:home_automation/domain/usecases/usecases.dart';

class GetxSplashScreenPresenter implements ISplashScreenPresenter {
  final ILoadCurrentAccount loadCurrentAccount;
  final _navigateToObserver = RxString();

  GetxSplashScreenPresenter({@required this.loadCurrentAccount});

  @override
  Stream<String> get navigateToStream => _navigateToObserver.stream;

  @override
  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }
}

class LoadCurrentAccountSpy extends Mock implements ILoadCurrentAccount {}

void main() {
  test('should call LoadCurrentAccount', () async {
    final loadCurrentAccount = LoadCurrentAccountSpy();
    final sut = GetxSplashScreenPresenter(loadCurrentAccount: loadCurrentAccount);

    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });
}
