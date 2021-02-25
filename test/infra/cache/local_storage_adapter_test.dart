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

  void mockDeleteError() => when(localStorage.deleteItem(any)).thenThrow(Exception());
  void mockSaveError() => when(localStorage.setItem(any, any)).thenThrow(Exception());
  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('should call LocalStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('should throw if setItem throws', () async {
      mockSaveError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('should call LocalStorage with correct values', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    String result;

    PostExpectation mockFetchCall() => when(localStorage.getItem(any));

    void mockFetch() {
      result = faker.randomGenerator.string(50);
      mockFetchCall().thenAnswer((_) => result);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(mockFetch);

    test('should call LocalStorage with correct values', () async {
      await sut.fetch(key);

      verify(localStorage.getItem(key)).called(1);
    });

    test('should return same value as localStorage', () async {
      final data = await sut.fetch(key);

      expect(data, result);
    });

    test('should throw if getItem throws', () async {
      mockFetchError();

      final future = sut.fetch(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
