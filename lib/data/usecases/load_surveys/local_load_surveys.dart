import 'package:meta/meta.dart';

import '../../../data/cache/cache.dart';
import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveys implements ILoadSurveys {
  final ICacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      // ignore: only_throw_errors
      if (data?.isEmpty != false) throw Exception();

      return _mapToEntity(data);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      _mapToEntity(data);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _mapToEntity(List<Map> mappedList) =>
      mappedList.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();

  List<Map> _mapToJson(List<SurveyEntity> list) => list.map((entity) => LocalSurveyModel.fromEntity(entity).toJson()).toList();
}
