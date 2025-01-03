import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parse_result.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parser.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository_impl.dart';
import 'package:zapping_flutter/data/repository/zapping/get_articles_result.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';

import 'zapping_repository_impl_test.mocks.dart';

@GenerateMocks([MyHttpClient, RssParser])
void main() {
  late ZappingRepositoryImpl zappingRepository;

  setUpAll(() {
    // todo this line is only needed when we do not mock all of the dependencies
    //  also, it might affect following tests
    configureDependencies();
  });

  // todo check if ZappingRepositoryImpl translates the input correctly
  test("good response from the http client and good parsing returns GetArticlesSuccess", () async {
    provideDummy<RssParseResult>(RssParseSuccess(const []));
    final mockHttp = MockMyHttpClient();
    final mockParser = MockRssParser();

    when(mockHttp.get(any, headers: anyNamed("headers"))).thenAnswer((_) async => Response("", 200));

    when(mockParser.parse(any)).thenReturn(RssParseSuccess([]));

    zappingRepository = ZappingRepositoryImpl(http: mockHttp, rssParser: mockParser);

    expect(await zappingRepository.getArticles(""), isA<GetArticlesSuccess>());
  });

  // todo the rss parser is not used here either, mock it
  test("ClientException in the http client returns GetArticlesHttpError", () async {
    final mockHttp = MockMyHttpClient();

    when(mockHttp.get(any, headers: anyNamed("headers"))).thenThrow(ClientException(""));

    zappingRepository = ZappingRepositoryImpl(http: mockHttp);

    expect(await zappingRepository.getArticles(""), isA<GetArticlesHttpError>());
  });

  test("good response from the http client but bad parsing returns GetArticlesParseError", () async {
    provideDummy<RssParseResult>(RssParseSuccess(const []));
    final mockHttp = MockMyHttpClient();
    final mockParser = MockRssParser();

    when(mockHttp.get(any, headers: anyNamed("headers"))).thenAnswer((_) async => Response("", 200));

    when(mockParser.parse(any)).thenReturn(RssParseException(Exception()));

    zappingRepository = ZappingRepositoryImpl(http: mockHttp, rssParser: mockParser);

    expect(await zappingRepository.getArticles(""), isA<GetArticlesParseError>());
  });
}
