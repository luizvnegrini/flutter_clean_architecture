import 'package:meta/meta.dart';

import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import './add_account.dart';

class RemoteAddAccount {
  final IHttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  @override
  Future<void> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}
