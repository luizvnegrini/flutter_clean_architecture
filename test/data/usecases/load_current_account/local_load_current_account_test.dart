import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

abstract class IFetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock implements IFetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });
}
