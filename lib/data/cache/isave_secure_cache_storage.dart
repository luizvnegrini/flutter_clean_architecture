abstract class ISaveSecureCacheStorage {
  Future<void> save({String key, String value});
}
