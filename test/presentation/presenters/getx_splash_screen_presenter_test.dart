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

    _navigateToObserver.value = '/home';
  }
}

class LoadCurrentAccountSpy extends Mock implements ILoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashScreenPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashScreenPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('should go to home page on sucess', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/home')));

    await sut.checkAccount();
  });
}
