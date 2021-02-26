import './survey_result.dart';

abstract class ISurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get surveyResultStream;

  Future<void> loadData();
}
