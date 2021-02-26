abstract class ISurveyResultPresenter {
  Stream<bool> get isLoadingStream;

  Stream<void> loadData();
}
