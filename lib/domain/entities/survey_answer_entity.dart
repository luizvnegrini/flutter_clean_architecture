import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyAnswerEntity extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  @override
  List get props => [image, answer, isCurrentAnswer, percent];

  const SurveyAnswerEntity({
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
    this.image,
  });
}
