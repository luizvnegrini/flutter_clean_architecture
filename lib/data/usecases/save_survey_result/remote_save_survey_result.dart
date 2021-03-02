import 'dart:core';
import 'package:meta/meta.dart';

import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult implements ISaveSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});

  @override
  Future<SurveyResultEntity> save({@required String answer}) async {
    try {
      final json = await httpClient.request(
        url: url,
        method: 'put',
        body: {'answer': answer},
      );

      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      // ignore: only_throw_errors
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
