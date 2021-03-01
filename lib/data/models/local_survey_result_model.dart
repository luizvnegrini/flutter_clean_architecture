import 'package:meta/meta.dart';

import '../../data/enums/enums.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    // ignore: only_throw_errors
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) throw HttpError.invalidData;

    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers'].map<LocalSurveyAnswerModel>((answerJson) => LocalSurveyAnswerModel.fromJson(answerJson)).toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      );

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) => LocalSurveyResultModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: entity.answers.map<LocalSurveyAnswerModel>((answer) => LocalSurveyAnswerModel.fromEntity(answer)).toList(),
      );

  Map toJson() => {
        'surveyId': surveyId,
        'question': question,
        'answers': answers.map<Map>((answer) => answer.toJson()).toList(),
      };
}
