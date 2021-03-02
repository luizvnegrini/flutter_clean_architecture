import 'dart:core';
import 'package:meta/meta.dart';

import '../../../domain/enums/enums.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});

  Future<void> save({@required String answer}) async {
    try {
      await httpClient.request(
        url: url,
        method: 'put',
        body: {'answer': answer},
      );
    } on HttpError catch (error) {
      // ignore: only_throw_errors
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
