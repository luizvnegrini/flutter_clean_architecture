import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements IHttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await client.post(url, headers: defaultHeaders, body: jsonBody).timeout(const Duration(seconds: 5));
      } else if (method == 'get') response = await client.get(url, headers: defaultHeaders).timeout(const Duration(seconds: 5));
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw HttpError.internalServerError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      // ignore: only_throw_errors
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      // ignore: only_throw_errors
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      // ignore: only_throw_errors
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      // ignore: only_throw_errors
      throw HttpError.notFound;
    } else {
      // ignore: only_throw_errors
      throw HttpError.internalServerError;
    }
  }
}
