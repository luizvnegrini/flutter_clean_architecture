import 'dart:core';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult implements ILoadSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveyResult({@required this.url, @required this.httpClient});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      // ignore: only_throw_errors
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
