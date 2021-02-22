import 'package:meta/meta.dart';

import '../../../data/http/http.dart';
import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveys implements ILoadSurveys {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final response = await httpClient.request(url: url, method: 'get');

      return response.map((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
    } on HttpError catch (error) {
      // ignore: only_throw_errors
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
