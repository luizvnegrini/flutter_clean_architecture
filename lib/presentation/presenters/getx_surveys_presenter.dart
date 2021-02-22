import 'package:get/get.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/surveys/surveys.dart';
import '../../utils/extensions/enum_extensions.dart';

class GetxSurveysPresenter implements ISurveysPresenter {
  final ILoadSurveys loadSurveys;

  final _isLoadingObserver = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>();

  @override
  Stream<bool> get isLoadingStream => _isLoadingObserver.stream;
  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

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
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoadingObserver.value = false;
    }
  }
}
