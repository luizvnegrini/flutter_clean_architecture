import 'package:home_automation/ui/pages/surveys/surveys.dart';

abstract class ISurveysPresenter {
  Stream<bool> isLoadingStream;
  Stream<List<SurveyViewModel>> surveysStream;

  Future<void> loadData();
}
