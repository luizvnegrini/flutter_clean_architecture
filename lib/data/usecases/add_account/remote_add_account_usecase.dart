import 'package:meta/meta.dart';

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
    await httpClient.request(url: url, method: 'post', body: body);
  }
}
