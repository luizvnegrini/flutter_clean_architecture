import 'package:home_automation/data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';
import '../http/http.dart';

ILoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'),
    );
