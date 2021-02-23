import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

class LocalLoadSurveys {
  final IFetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<void> load() async {
    await fetchCacheStorage.fetch('surveys');
  }
}

class FetchCacheStorageSpy extends Mock implements IFetchCacheStorage {}

abstract class IFetchCacheStorage {
  Future<void> fetch(String key);
}

void main() {
  test('should call FetchCacheStorage with correct key', () async {
    final fetchCacheStorage = FetchCacheStorageSpy();
    final sut = LocalLoadSurveys(
      fetchCacheStorage: fetchCacheStorage,
    );

    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}
