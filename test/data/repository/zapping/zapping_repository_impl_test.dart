import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/http_client/model/http_get_result.dart';
import 'package:zapping_flutter/data/repository/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/repository/rss/model/my_rss_item.dart';
import 'package:zapping_flutter/data/repository/rss/model/rss_parse_result.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parser.dart';
import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository_impl.dart';

import 'zapping_repository_impl_test.mocks.dart';

@GenerateMocks([MyHttpClient, RssParser])
void main() {
  late ZappingRepositoryImpl zappingRepository;
  late MockMyHttpClient myHttpClient;
  late MockRssParser rssParser;

  const parserOutput = [
    MyRssItem(title: "Al Hilal x Al-Ettifaq - 08/11 14:45 - SportTV 1", pubDate: "Fri, 08 Nov 2024 14:45:00"),
    MyRssItem(title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1", pubDate: "Fri, 08 Nov 2024 17:00:00"),
    MyRssItem(title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +", pubDate: "Fri, 08 Nov 2024 18:00:00"),
  ];

  const expectedRepositoryOutput = [
    MyArticle(title: "Al Hilal x Al-Ettifaq - 08/11 14:45 - SportTV 1", date: "Fri, 08 Nov 2024 14:45:00"),
    MyArticle(title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1", date: "Fri, 08 Nov 2024 17:00:00"),
    MyArticle(title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +", date: "Fri, 08 Nov 2024 18:00:00"),
  ];

  setUpAll(() {
    provideDummy<HttpGetResult>(const HttpGetSuccess(""));
    provideDummy<RssParseResult>(RssParseSuccess(const []));
  });

  setUp(() {
    myHttpClient = MockMyHttpClient();
    rssParser = MockRssParser();
    zappingRepository = ZappingRepositoryImpl(http: myHttpClient, rssParser: rssParser);
  });

  test("good http response and good parsing returns GetArticlesSuccess", () async {
    when(myHttpClient.getAsString(any, headers: anyNamed("headers"))).thenAnswer((_) async => const HttpGetSuccess(""));
    when(rssParser.parse(any)).thenReturn(RssParseSuccess(parserOutput));

    final result = await zappingRepository.getArticles("");

    // todo why not compare the entire class?
    expect(result, isA<GetArticlesSuccess>());
    // expect((result as GetArticlesSuccess).articles, expectedRepositoryOutput);
  });

  group("failure tests", () {
    test("unsuccessful http response returns GetArticlesHttpError", () async {
      when(myHttpClient.getAsString(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => const HttpGetUnsuccessfulResponse(""));

      expect(await zappingRepository.getArticles(""), isA<GetArticlesHttpError>());
    });

    test("exception in http response returns GetArticlesHttpError", () async {
      when(myHttpClient.getAsString(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => HttpGetException(Exception()));

      expect(await zappingRepository.getArticles(""), isA<GetArticlesHttpError>());
    });

    test("good http response and bad parsing returns GetArticlesParseError", () async {
      when(myHttpClient.getAsString(any, headers: anyNamed("headers"))).thenAnswer((_) async => HttpGetSuccess(""));
      when(rssParser.parse(any)).thenReturn(RssParseException(Exception()));

      final result = await zappingRepository.getArticles("");

      expect(result, isA<GetArticlesParseError>());
    });

    test("exception thrown returns GetArticlesOtherExceptionError", () async {
      final exceptionThrown = Exception();

      when(myHttpClient.getAsString(any, headers: anyNamed("headers"))).thenThrow(exceptionThrown);
      when(rssParser.parse(any)).thenReturn(RssParseSuccess(const []));

      final result = await zappingRepository.getArticles("");

      expect(result, isA<GetArticlesOtherExceptionError>());
      expect((result as GetArticlesOtherExceptionError).exception, exceptionThrown);
    });
  });
}
