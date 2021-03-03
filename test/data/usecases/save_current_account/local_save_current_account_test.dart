import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/data/cache/cache.dart';
import 'package:home_automation/data/usecases/usecases.dart';

class SaveSecureCacheStorageSpy extends Mock implements ISaveSecureCacheStorage {}

void main() {
  LocalSaveCurrentAccountUsecase sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  void mockError() {
    when(saveSecureCacheStorage.save(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccountUsecase(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  test('should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.save(key: 'token', value: account.token));
  });

  test('should throw UnexpectedError if SaveSecureCacheStorage trhows', () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
