import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import './survey_answer_viewmodel.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  @override
  List get props => [surveyId, question, answers];

  const SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });
}
