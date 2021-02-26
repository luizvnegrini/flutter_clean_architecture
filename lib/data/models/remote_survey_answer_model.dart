import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../enums/enums.dart';

class RemoteSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
    this.image,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    // ignore: only_throw_errors
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) throw HttpError.invalidData;

    return RemoteSurveyAnswerModel(
      answer: json['answer'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
      image: json['image'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAccountAnswer,
        percent: percent,
      );
}
