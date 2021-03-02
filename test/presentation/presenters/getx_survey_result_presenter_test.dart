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

class SaveSurveyResultSpy extends Mock implements ISaveSurveyResult {}

void main() {
  LoadSurveyResultSpy loadSurveyResult;
  SaveSurveyResultSpy saveSurveyResult;
  GetxSurveyResultPresenter sut;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResult.save(answer: anyNamed('answer')));

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

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();

    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );

    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('loadData', () {
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
            surveyId: loadResult.surveyId,
            question: loadResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: loadResult.answers[0].image,
                answer: loadResult.answers[0].answer,
                isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                percent: '${loadResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: loadResult.answers[1].answer,
                isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                percent: '${loadResult.answers[1].percent}%',
              ),
            ],
          ))));

      await sut.loadData();
    });

    test('should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);

      // ignore: unawaited_futures
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      // ignore: unawaited_futures
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });

    test('should emit correct events on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);

      // ignore: unawaited_futures
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.loadData();
    });
  });

  group('save', () {
    test('should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('should emit correct events on success', () async {
      // ignore: unawaited_futures
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((surveys) => expect(
          surveys,
          SurveyResultViewModel(
            surveyId: saveResult.surveyId,
            question: saveResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: saveResult.answers[0].image,
                answer: saveResult.answers[0].answer,
                isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                percent: '${saveResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: saveResult.answers[1].answer,
                isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                percent: '${saveResult.answers[1].percent}%',
              ),
            ],
          ))));

      await sut.save(answer: answer);
    });

    test('should emit correct events on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      // ignore: unawaited_futures
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      // ignore: unawaited_futures
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });

    test('should emit correct events on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      // ignore: unawaited_futures
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.save(answer: answer);
    });
  });
}
