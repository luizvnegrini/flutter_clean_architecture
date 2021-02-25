import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/composites/composites.dart';
import '../../../main/factories/factories.dart';
import '../http/http.dart';

ILoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'),
    );

ILoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(
      cacheStorage: makeLocalStorageAdapter(),
    );

ILoadSurveys makeRemoteLoadSurveysWithLocalFallback() => RemoteLoadSurveysWithLocalFallback(
      remote: makeRemoteLoadSurveys(),
      local: makeLocalLoadSurveys(),
    );
