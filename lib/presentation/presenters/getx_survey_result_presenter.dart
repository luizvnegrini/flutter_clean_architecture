import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/survey_result/survey_result.dart';
import '../../utils/extensions/enum_extensions.dart';

class GetxSurveyResultPresenter implements ISurveyResultPresenter {
  final ILoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoadingObserver = true.obs;
  final _isSessionExpired = RxBool();
  final _surveyResult = Rx<SurveyResultViewModel>();

  @override
  Stream<bool> get isLoadingStream => _isLoadingObserver.stream;
  @override
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;
  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
  });

  @override
  Future<void> loadData() async {
    try {
      _isLoadingObserver.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map((answer) => SurveyAnswerViewModel(
                  image: answer.image,
                  answer: answer.answer,
                  isCurrentAnswer: answer.isCurrentAnswer,
                  percent: '${answer.percent}%',
                ))
            .toList(),
      );
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoadingObserver.value = false;
    }
  }
}
