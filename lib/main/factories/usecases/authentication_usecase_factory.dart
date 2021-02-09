import '../../../data/usecases/remote_authentication_usecase.dart';
import '../../../domain/usecases/usecases.dart';
import '../http/http.dart';

IAuthentication makeRemoteAuthentication() => RemoteAuthentication(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('login'),
    );
