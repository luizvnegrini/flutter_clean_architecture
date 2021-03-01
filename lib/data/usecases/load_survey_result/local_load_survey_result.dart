import 'package:home_automation/data/models/models.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalLoadSurveyResult implements ILoadSurveyResult {
  final ICacheStorage cacheStorage;

  LocalLoadSurveyResult({@required this.cacheStorage});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');

      if (data?.isEmpty != false) throw Exception();

      return LocalSurveyResultModel.fromJson(data).toEntity();
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}
