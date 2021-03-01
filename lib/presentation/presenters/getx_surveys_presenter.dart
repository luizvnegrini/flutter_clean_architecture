import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/surveys/surveys.dart';
import '../../utils/extensions/enum_extensions.dart';

class GetxSurveysPresenter implements ISurveysPresenter {
  final ILoadSurveys loadSurveys;

  final _isLoadingObserver = true.obs;
  final _isSessionExpired = RxBool();
  final _surveys = Rx<List<SurveyViewModel>>();
  final _navigateToObserver = RxString();

  @override
  Stream<bool> get isLoadingStream => _isLoadingObserver.stream;
  @override
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;
  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;
  @override
  Stream<String> get navigateToStream => _navigateToObserver.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      _isLoadingObserver.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MMM yyyy').format(survey.dateTime),
                didAnswer: survey.didAnswer,
              ))
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveys.subject.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoadingObserver.value = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateToObserver.value = '/survey_result/$surveyId';
  }
}
