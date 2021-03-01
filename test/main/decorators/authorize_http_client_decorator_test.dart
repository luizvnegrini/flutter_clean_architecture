import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/data/http/http.dart';
import 'package:home_automation/main/decorators/decorators.dart';
import 'package:home_automation/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock implements IFetchSecureCacheStorage {}

class DeleteSecureCacheStorageSpy extends Mock implements IDeleteSecureCacheStorage {}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  AuthorizeHttpClientDecorator sut;
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  DeleteSecureCacheStorageSpy deleteSecureCacheStorage;
  HttpClientSpy httpClient;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall() => when(fetchSecureCacheStorage.fetchSecure(any));
  PostExpectation mockHttpResponseCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  void mockHttpResponseError(HttpError error) {
    mockHttpResponseCall().thenThrow(error);
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    deleteSecureCacheStorage = DeleteSecureCacheStorageSpy();
    httpClient = HttpClientSpy();

    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    mockToken();
    mockHttpResponse();
  });

  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token},
    )).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {
        'x-access-token': token,
        'any_header': 'any_value',
      },
    )).called(1);
  });

  test('should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('should throw ForbiddenError if FetchSecureCacheStorage throws', () async {
    mockTokenError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorage.deleteSecure('token')).called(1);
  });

  test('should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });

  test('should delete cache if request throws ForbiddenError', () async {
    mockHttpResponseError(HttpError.forbidden);

    final future = sut.request(url: url, method: method, body: body);
    await untilCalled(deleteSecureCacheStorage.deleteSecure('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorage.deleteSecure('token')).called(1);
  });
}
