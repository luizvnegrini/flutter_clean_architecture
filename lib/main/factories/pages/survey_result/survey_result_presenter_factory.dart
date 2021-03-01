import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

ISurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) => GetxSurveyResultPresenter(
      loadSurveyResult: makeRemoteLoadSurveyResult(surveyId),
      surveyId: surveyId,
    );
