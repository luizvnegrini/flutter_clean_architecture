import 'package:meta/meta.dart';

import './survey_answer_viewmodel.dart';

class SurveyResultViewModel {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  const SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });
}
