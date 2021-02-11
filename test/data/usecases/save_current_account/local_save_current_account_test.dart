import 'package:faker/faker.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:meta/meta.dart';
import 'package:home_automation/domain/entities/account_entity.dart';
import 'package:home_automation/domain/usecases/interfaces/isave_current_account_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements ISaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({String key, String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('should throw UnexpectedError if SaveSecureCacheStorage trhows', () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
