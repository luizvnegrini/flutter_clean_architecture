import 'package:meta/meta.dart';

import '../../data/enums/enums.dart';
import '../../domain/entities/entities.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  factory RemoteSurveyModel.fromJson(Map json) {
    // ignore: only_throw_errors
    if (!json.keys.toSet().containsAll(['id', 'question', 'date', 'didAnswer'])) throw HttpError.invalidData;

    return RemoteSurveyModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      didAnswer: json['didAnswer'],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: DateTime.parse(date),
        didAnswer: didAnswer,
      );
}