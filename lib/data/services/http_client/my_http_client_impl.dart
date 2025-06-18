import 'package:injectable/injectable.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/services/http_client/model/http_get_result.dart';
import 'package:zapping_flutter/data/services/http_client/my_http_client.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';
import 'package:zapping_flutter/infrastructure/response_extension.dart';

@LazySingleton(as: MyHttpClient)
final class HttpClientImpl implements MyHttpClient {
  // I am using http because dio was not correctly decoding accents
  late final _http = getIt<HttpWithMiddleware>();

  @override
  Future<HttpGetResult> getAsString(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _http.get(Uri.parse(url), headers: headers);

      if (response.isSuccessful) {
        return HttpGetSuccess(response.body);
      } else {
        return HttpGetUnsuccessfulResponse(response.body);
      }
    } on Exception catch (ex) {
      return HttpGetException(ex);
    }
  }
}
