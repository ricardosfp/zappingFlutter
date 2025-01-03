import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/repository/http_client/my_http_client.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';

@LazySingleton(as: MyHttpClient)
final class HttpClientImpl implements MyHttpClient {
  // I am using http because dio was not correctly decoding accents
  late final _http = getIt<HttpWithMiddleware>();

  // todo what to return if the request is not successful? maybe create more sealed classes
  @override
  Future<Response> get(String url, {Map<String, String>? headers}) async {
    return await _http.get(Uri.parse(url), headers: headers);
  }
}
