import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/data/usecases/usecases.dart';
import 'package:home_automation/data/http/http.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;
  Map surveyResult;

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  Map mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'date': faker.date.dateTime().toIso8601String(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
        ]
      };

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
    answer = faker.lorem.sentence();

    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(httpClient.request(
      url: url,
      method: 'put',
      body: {'answer': answer},
    ));
  });

  test('should return surveyResult on 200', () async {
    final result = await sut.save(answer: answer);

    expect(
      result,
      SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
            image: surveyResult['answers'][0]['image'],
            answer: surveyResult['answers'][0]['answer'],
            isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][0]['percent'],
          ),
          SurveyAnswerEntity(
            answer: surveyResult['answers'][1]['answer'],
            isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][1]['percent'],
          ),
        ],
      ),
    );
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.internalServerError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
