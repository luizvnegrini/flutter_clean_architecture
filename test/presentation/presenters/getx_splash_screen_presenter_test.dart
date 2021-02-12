import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/presentation/presenters/presenters.dart';
import 'package:home_automation/domain/entities/account_entity.dart';
import 'package:home_automation/domain/usecases/usecases.dart';

class LoadCurrentAccountSpy extends Mock implements ILoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashScreenPresenter sut;

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashScreenPresenter(loadCurrentAccount: loadCurrentAccount);

    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });

  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('should go to home page on sucess', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/home')));

    await sut.checkAccount();
  });

  test('should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount();
  });

  test('should go to login page on error', () async {
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount();
  });
}
