import 'package:http/http.dart';

abstract interface class MyHttpClient {
  Future<Response> get(String url, {Map<String, String>? headers});
}
