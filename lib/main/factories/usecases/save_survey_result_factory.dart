import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';
import '../http/http.dart';

ISaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) => RemoteSaveSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );
