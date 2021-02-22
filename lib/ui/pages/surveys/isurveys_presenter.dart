import 'package:home_automation/ui/pages/surveys/surveys.dart';

abstract class ISurveysPresenter {
  Stream<bool> isLoadingStream;
  Stream<List<SurveyViewModel>> loadSurveysStream;

  Future<void> loadData();
}
