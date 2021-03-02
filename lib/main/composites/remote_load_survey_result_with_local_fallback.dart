import 'package:meta/meta.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/usecases/interfaces/interfaces.dart';

class RemoteLoadSurveyResultWithLocalFallback implements ILoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote, @required this.local});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult);
      return surveyResult;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;

      await local.validate(surveyId);
      return local.loadBySurvey(surveyId: surveyId);
    }
  }
}
