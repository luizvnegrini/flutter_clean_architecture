import 'package:meta/meta.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../enums/enums.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    // ignore: only_throw_errors
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) throw HttpError.invalidData;

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers'].map<RemoteSurveyAnswerModel>((answerJson) => RemoteSurveyAnswerModel.fromJson(answerJson)).toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      );
}
