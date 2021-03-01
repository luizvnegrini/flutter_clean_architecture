import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class SecureStorageAdapter implements ISaveSecureCacheStorage, IFetchSecureCacheStorage, IDeleteSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter({@required this.secureStorage});

  @override
  Future<void> save({@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<String> fetch(String key) async {
    final value = await secureStorage.read(key: key);
    return value;
  }
}
