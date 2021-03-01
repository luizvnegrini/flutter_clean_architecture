import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/presentation/presenters/presenters.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:home_automation/ui/pages/surveys/surveys.dart';
import 'package:home_automation/domain/entities/survey_entity.dart';
import 'package:home_automation/domain/usecases/usecases.dart';
import 'package:home_automation/utils/extensions/enum_extensions.dart';

class LoadSurveysSpy extends Mock implements ILoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2020, 2, 20),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2020, 10, 3),
          didAnswer: false,
        )
      ];

  void mockLoadSurveysError() => mockLoadSurveysCall().thenThrow(DomainError.unexpected);
  void mockAccessDeniedError() => mockLoadSurveysCall().thenThrow(DomainError.accessDenied);

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;

    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    mockLoadSurveys(mockValidData());
  });

  test('should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('should emit correct events on success', () async {
    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '20 Dev 2020', didAnswer: surveys[0].didAnswer),
          SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '03 Out 2020', didAnswer: surveys[1].didAnswer),
        ])));

    await sut.loadData();
  });

  test('should emit correct events on failure', () async {
    mockLoadSurveysError();

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

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

  test('should go to SurveyResultPage on survey click', () async {
    // ignore: unawaited_futures
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/survey_result/any_id')));

    sut.goToSurveyResult('any_id');
  });
}
