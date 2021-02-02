import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/usecases/usecases.dart';

import 'package:home_automation/data/usecases/usecases.dart';
import 'package:home_automation/data/http/http_client.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct values', () async {
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
}
