import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/composites/composites.dart';
import '../factories.dart';
import '../http/http.dart';

ILoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) => RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );

ILoadSurveyResult makeLocalLoadSurveyResult(String surveyId) => LocalLoadSurveyResult(
      cacheStorage: makeLocalStorageAdapter(),
    );

ILoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) => RemoteLoadSurveyResultWithLocalFallback(
      remote: makeRemoteLoadSurveyResult(surveyId),
      local: makeLocalLoadSurveyResult(surveyId),
    );
