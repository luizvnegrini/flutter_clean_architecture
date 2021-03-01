import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/main/composites/composites.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/data/usecases/usecases.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));
  PostExpectation mockLocalLoadCall() => when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          )
        ],
      );

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);
  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  void mockRemoteLoad() {
    remoteResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }

  void mockLocalLoad() {
    localResult = mockSurveyResult();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
    surveyId = faker.guid.guid();

    mockSurveyResult();
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: remoteResult)).called(1);
  });

  test('should call local save with remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local LoadBySurvey on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should return local data', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('should throw UnexpectedError if local load fails', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
