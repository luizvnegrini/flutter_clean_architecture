import 'package:http/http.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http_adapter.dart';

IHttpClient makeHttpAdapter() {
  final client = Client();

  return HttpAdapter(client);
}
