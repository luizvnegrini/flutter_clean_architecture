import 'package:faker/faker.dart';
import 'package:home_automation/data/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/data/cache/cache.dart';
import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/domain/enums/enums.dart';

class CacheStorageSpy extends Mock implements ICacheStorage {}

void main() {
  CacheStorageSpy cacheStorage;
  LocalLoadSurveys sut;
  List<Map> data;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2020-07-20T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'true',
        }
      ];

  PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

  void mockFetch(List<Map> list) {
    data = list;
    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveys(
      cacheStorage: cacheStorage,
    );

    mockFetch(mockValidData());
  });

  group('load', () {
    test('should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(2020, 07, 20),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          dateTime: DateTime.utc(2019, 02, 02),
          didAnswer: true,
        ),
      ]);
    });

    test('should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is empty', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      mockFetch([
        {
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(2020, 07, 20),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          dateTime: DateTime.utc(2019, 02, 02),
          didAnswer: true,
        ),
      ]);
    });

    test('should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is empty', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      mockFetch([
        {
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
