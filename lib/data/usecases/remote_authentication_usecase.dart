import 'package:home_automation/data/usecases/usecases.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}
