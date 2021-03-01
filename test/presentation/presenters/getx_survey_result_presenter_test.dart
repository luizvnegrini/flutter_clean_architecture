import 'package:faker/faker.dart';
import 'package:home_automation/ui/pages/survey_result/survey_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/presentation/presenters/presenters.dart';
import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/usecases/usecases.dart';
import 'package:home_automation/utils/extensions/enum_extensions.dart';

class LoadSurveyResultSpy extends Mock implements ILoadSurveyResult {}

void main() {
  LoadSurveyResultSpy loadSurveyResult;
  GetxSurveyResultPresenter sut;
  SurveyResultEntity surveyResult;
  String surveyId;

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  SurveyResultEntity mockValidData() => SurveyResultEntity(surveyId: faker.guid.guid(), question: faker.lorem.sentence(), answers: [
        SurveyAnswerEntity(
          image: faker.internet.httpUrl(),
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100),
        ),
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100),
        ),
      ]);

  void mockLoadSurveyResultError() => mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);
  void mockAccessDeniedError() => mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;

    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );

    mockLoadSurveyResult(mockValidData());
  });

  test('should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should emit correct events on success', () async {
    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(expectAsync1((surveys) => expect(
        surveys,
        SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: [
            SurveyAnswerViewModel(
              image: surveyResult.answers[0].image,
              answer: surveyResult.answers[0].answer,
              isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
              percent: '${surveyResult.answers[0].percent}%',
            ),
            SurveyAnswerViewModel(
              answer: surveyResult.answers[1].answer,
              isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
              percent: '${surveyResult.answers[1].percent}%',
            ),
          ],
        ))));

    await sut.loadData();
  });

  test('should emit correct events on access denied', () async {
    mockAccessDeniedError();

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ignore: unawaited_futures
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('should emit correct events on failure', () async {
    mockLoadSurveyResultError();

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
