import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/repository/implementation/zapping_repository_impl.dart';
import 'package:zapping_flutter/data/repository/model/get_articles_result.dart';
import 'package:zapping_flutter/di/di.dart';

import 'zapping_repository_impl_test.mocks.dart';

@GenerateMocks([HttpWithMiddleware])
void main() {
  late ZappingRepositoryImpl zappingRepository;

  setUpAll(() {
    configureDependencies();
  });

  test("ClientException in the http client returns GetArticlesHttpError",
      () async {
    final mockHttp = MockHttpWithMiddleware();

    when(mockHttp.get(any, headers: anyNamed("headers")))
        .thenThrow(ClientException(""));

    zappingRepository = ZappingRepositoryImpl(http: mockHttp);

    expect(
        await zappingRepository.getArticles(""), isA<GetArticlesHttpError>());
  });

  // todo I should mock both the http client and the parser
  // test(
  //     "good response from the http client and good parsing returns GetArticlesSuccess",
  //     () {
  //   final mockHttp = MockHttpWithMiddleware();
  //
  //   when(mockHttp.get(any, headers: anyNamed("headers")))
  //       .thenAnswer((_) async => Response("", 200));
  //
  //   zappingRepository = ZappingRepositoryImpl(http: mockHttp);
  // });
}
