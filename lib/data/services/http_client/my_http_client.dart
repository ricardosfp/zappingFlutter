import 'package:zapping_flutter/data/services/http_client/model/http_get_result.dart';

abstract interface class MyHttpClient {
  Future<HttpGetResult> getAsString(String url, {Map<String, String>? headers});
}
