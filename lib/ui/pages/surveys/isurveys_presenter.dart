abstract class ISurveysPresenter {
  Stream<bool> isLoadingStream;

  Future<void> loadData();
}
