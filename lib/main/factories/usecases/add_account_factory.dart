import 'package:home_automation/data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';
import '../http/http.dart';

IAddAccount makeRemoteAddAccount() => RemoteAddAccount(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('signup'),
    );
