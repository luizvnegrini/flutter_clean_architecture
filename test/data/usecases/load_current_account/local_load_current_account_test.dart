import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/data/cache/cache.dart';
import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock implements IFetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() => when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => token);
  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();

    mockFetchSecure();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('should throw UnexpectedError if FetchSecureCacheStorage throws', () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
