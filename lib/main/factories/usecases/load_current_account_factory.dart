import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';

ILoadCurrentAccount makeLocalLoadCurrentAccount() => LocalLoadCurrentAccount(fetchSecureCacheStorage: makeLocalStorageAdapter());
