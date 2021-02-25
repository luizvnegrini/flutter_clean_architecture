import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:localstorage/localstorage.dart';

import 'package:home_automation/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageSpy localStorage;
  LocalStorageAdapter sut;
  String key;
  dynamic value;

  void mockDeleteItemError() => when(localStorage.deleteItem(any)).thenThrow(Exception());
  void mockSetItemError() => when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  test('should call LocalStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });

  test('should throw if deleteItem throws', () async {
    mockDeleteItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsA(const TypeMatcher<Exception>()));
  });

  test('should throw if setItem throws', () async {
    mockSetItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}
