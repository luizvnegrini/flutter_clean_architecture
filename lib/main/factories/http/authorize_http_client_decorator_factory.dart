import '../../../data/http/http.dart';
import '../../../main/decorators/decorators.dart';
import '../../../main/factories/factories.dart';

IHttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
      deleteSecureCacheStorage: makeSecureStorageAdapter(),
    );
