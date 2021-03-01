import 'package:faker/faker.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/domain/usecases/usecases.dart';
import 'package:home_automation/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements ILoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote, @required this.local});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: surveyResult);
    return surveyResult;
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity surveyResult;

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

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

  void mockRemoteLoad() {
    surveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
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
  });

  test('should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: surveyResult)).called(1);
  });

  test('should call local save with remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, surveyResult);
  });

  test('should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
