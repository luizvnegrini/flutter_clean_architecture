import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/survey_result/survey_result.dart';
import '../../utils/extensions/enum_extensions.dart';

class GetxSurveyResultPresenter extends GetxController with SessionManager, LoadingManager implements ISurveyResultPresenter {
  final ILoadSurveyResult loadSurveyResult;
  final ISaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>();

  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.saveSurveyResult,
    @required this.surveyId,
  });

  Future<void> showResultOnAction(Future<SurveyResultEntity> Function() action) async {
    try {
      isLoading = true;
      final surveyResult = await action();
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
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> loadData() async {
    await showResultOnAction(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  @override
  Future<void> save({@required String answer}) async {
    await showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }
}
