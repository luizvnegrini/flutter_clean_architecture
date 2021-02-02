import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/usecases/usecases.dart';

import 'package:home_automation/data/enums/enums.dart';
import 'package:home_automation/data/usecases/usecases.dart';
import 'package:home_automation/data/http/http_client.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
  });

  test('should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });

  test('should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
