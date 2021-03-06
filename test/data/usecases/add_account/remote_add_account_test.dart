import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/usecases/usecases.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/data/http/http.dart';
import 'package:home_automation/data/enums/enums.dart';
import 'package:home_automation/data/usecases/usecases.dart';
import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAddAccount sut;
  AddAccountParams params;
  Map apiResult;

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAddAccount();

    mockHttpData(FakeAccountFactory.makeApiJson());
  });

  test('should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'name': params.name,
        'email': params.email,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation,
      },
    ));
  });

  test('should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.internalServerError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw EmailInUse if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('should return an Account if HttpClient returns 200', () async {
    final account = await sut.add(params);

    expect(account.token, apiResult['accessToken']);
  });

  test('should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
