import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/cache.dart';

SecureStorageAdapter makeSecureStorageAdapter() {
  const secureStorage = FlutterSecureStorage();

  return SecureStorageAdapter(secureStorage: secureStorage);
}
