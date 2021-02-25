import 'package:meta/meta.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements ILoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys);

      return surveys;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;

      await local.validate();
      return local.load();
    }
  }
}
