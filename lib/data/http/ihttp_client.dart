import 'package:meta/meta.dart';

abstract class IHttpClient<TResponse> {
  Future<TResponse> request({
    @required String url,
    @required String method,
    Map body,
  });
}
