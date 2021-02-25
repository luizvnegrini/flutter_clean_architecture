import 'package:faker/faker.dart';
import 'package:home_automation/domain/entities/survey_entity.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:home_automation/data/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<void> load() async {
    final surveys = await remote.load();
    await local.save(surveys);
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  RemoteLoadSurveysWithLocalFallback sut;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean())
      ];

  void mockRemoteLoad() {
    surveys = mockSurveys();

    when(remote.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
      local: local,
    );

    mockRemoteLoad();
  });

  test('should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('should call local save with remote data', () async {
    await sut.load();

    verify(local.save(surveys)).called(1);
  });
}
