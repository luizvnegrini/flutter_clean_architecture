import '../../../domain/entities/entities.dart';

abstract class ILoadSurveys {
  Future<List<SurveyEntity>> load();
}
