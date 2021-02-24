import 'package:meta/meta.dart';

import '../../../data/cache/cache.dart';
import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveys implements ILoadSurveys {
  final IFetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await fetchCacheStorage.fetch('surveys');

      // ignore: only_throw_errors
      if (data?.isEmpty != false) throw Exception();

      return data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}