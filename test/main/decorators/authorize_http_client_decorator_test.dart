import 'package:faker/faker.dart';
import 'package:home_automation/data/http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:home_automation/data/cache/cache.dart';

class AuthorizeHttpClientDecorator {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;
  final IHttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');

    final authorizeHeaders = {'x-access-token': token};
    await decoratee.request(url: url, method: method, body: body, headers: authorizeHeaders);
  }
}

class FetchSecureCacheStorageSpy extends Mock implements IFetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  AuthorizeHttpClientDecorator sut;
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  HttpClientSpy httpClient;
  String url;
  String method;
  Map body;
  String token;

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecureCacheStorage.fetchSecure(any)).thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    mockToken();
  });

  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);

    verify(httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token})).called(1);
  });
}
