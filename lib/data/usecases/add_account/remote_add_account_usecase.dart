import 'package:home_automation/data/models/remote_account_model.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import './add_account.dart';

class RemoteAddAccount implements IAddAccount {
  final IHttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      // ignore: only_throw_errors
      throw error == HttpError.forbidden ? DomainError.emailInUse : DomainError.unexpected;
    }
  }
}
