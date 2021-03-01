import 'package:home_automation/ui/pages/surveys/surveys.dart';

abstract class ISurveysPresenter {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String> get navigateToStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
}
