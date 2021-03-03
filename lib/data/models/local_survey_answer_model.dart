import 'package:home_automation/data/enums/enums.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

class LocalSurveyAnswerModel {
  String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
    this.image,
  });

  // ignore: prefer_expression_function_bodies
  factory LocalSurveyAnswerModel.fromJson(Map json) {
    // ignore: only_throw_errors
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAnswer', 'percent'])) throw HttpError.invalidData;

    return LocalSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      percent: int.parse(json['percent']),
      isCurrentAnswer: json['isCurrentAnswer'].toLowerCase() == 'true',
    );
  }

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) => LocalSurveyAnswerModel(
        image: entity.image,
        answer: entity.answer,
        percent: entity.percent,
        isCurrentAnswer: entity.isCurrentAnswer,
      );

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );

  Map toJson() => {
        'image': image,
        'answer': answer,
        'isCurrentAnswer': isCurrentAnswer.toString(),
        'percent': percent.toString(),
      };
}
