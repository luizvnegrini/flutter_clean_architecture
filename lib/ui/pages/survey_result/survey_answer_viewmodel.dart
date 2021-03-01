import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyAnswerViewModel extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  @override
  List get props => [image, answer, isCurrentAnswer, percent];

  const SurveyAnswerViewModel({
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
    this.image,
  });
}
