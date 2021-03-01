import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements IHttpClient {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;
  final IDeleteSecureCacheStorage deleteSecureCacheStorage;
  final IHttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.deleteSecureCacheStorage,
    @required this.decoratee,
  });

  @override
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');

      final authorizeHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(url: url, method: method, body: body, headers: authorizeHeaders);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) rethrow;

      await deleteSecureCacheStorage.deleteSecure('token');
      // ignore: only_throw_errors
      throw HttpError.forbidden;
    }
  }
}
