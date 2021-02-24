abstract class ICacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
}
