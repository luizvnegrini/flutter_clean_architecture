import 'package:home_automation/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/data/http/http.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/entities/entities.dart';

import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> list;

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);

    mockHttpData(FakeSurveysFactory.makeApiJson());
  });

  test('should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      )
    ]);
  });

  test('should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData(FakeSurveysFactory.makeInvalidApiJson());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.internalServerError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
