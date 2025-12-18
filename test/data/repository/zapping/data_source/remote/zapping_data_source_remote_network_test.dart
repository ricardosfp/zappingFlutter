import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/remote/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/remote/zapping_data_source_remote_network.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/services/http_client/model/http_get_result.dart';
import 'package:zapping_flutter/data/services/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/services/rss/model/my_rss_item.dart';
import 'package:zapping_flutter/data/services/rss/model/rss_parse_result.dart';
import 'package:zapping_flutter/data/services/rss/rss_parser.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

import 'zapping_data_source_remote_network_test.mocks.dart';

@GenerateMocks([MyHttpClient, RssParser])
void main() {
  late MockMyHttpClient httpClient;
  late MockRssParser rssParser;

  late ZappingDataSourceRemote dataSource;

  const zappingUrl = "";
  const httpSuccess = HttpGetSuccess("");

  const List<MyRssItem> parserOutput = [
    MyRssItem(
      title: "Al Hilal x Al-Ettifaq - 08/11 14:45 - SportTV 1",
      pubDate: "Fri, 08 Nov 2024 14:45:00",
    ),
    MyRssItem(
      title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1",
      pubDate: "Fri, 08 Nov 2024 17:00:00",
    ),
    MyRssItem(
      title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +",
      pubDate: "Fri, 08 Nov 2024 18:00:00",
    ),
  ];

  final List<MyArticle> getArticlesOutput = [
    MyArticle(
      title: "Al Hilal x Al-Ettifaq - 08/11 14:45 - SportTV 1",
      date: DateTime(2024, 11, 8, 14, 45),
    ),
    MyArticle(
      title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1",
      date: DateTime(2024, 11, 8, 17),
    ),
    MyArticle(
      title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +",
      date: DateTime(2024, 11, 8, 18),
    ),
  ];

  void verifyBothFunctionsCalled(String httpBody) {
    verify(
      httpClient.getAsString(
        zappingUrl,
        headers: argThat(equals({"user-agent": ""}), named: "headers"),
      ),
    ).called(1);
    verify(rssParser.parse(httpBody)).called(1);

    verifyNoMoreInteractions(httpClient);
    verifyNoMoreInteractions(rssParser);
  }

  setUpAll(() {
    provideDummy<HttpGetResult>(httpSuccess);
    provideDummy<RssParseResult>(RssParseSuccess([]));
  });

  setUp(() {
    httpClient = MockMyHttpClient();
    rssParser = MockRssParser();

    dataSource = ZappingDataSourceRemoteNetwork(httpClient, rssParser, zappingUrl);
  });

  group("getArticles", () {
    test("empty list from the parser returns Success with an empty list", () async {
      when(
        httpClient.getAsString(any, headers: anyNamed("headers")),
      ).thenAnswer((_) async => httpSuccess);
      when(rssParser.parse(any)).thenReturn(RssParseSuccess([]));

      final result = await dataSource.getArticles();

      expect(result, Success<List<MyArticle>>([]));

      verifyBothFunctionsCalled(httpSuccess.bodyAsString);
    });

    test("non empty list from the parser returns Success with a non empty list", () async {
      when(
        httpClient.getAsString(any, headers: anyNamed("headers")),
      ).thenAnswer((_) async => httpSuccess);
      when(rssParser.parse(any)).thenReturn(RssParseSuccess(parserOutput));

      final result = await dataSource.getArticles();

      expect(result, Success(getArticlesOutput));

      verifyBothFunctionsCalled(httpSuccess.bodyAsString);
    });

    group("failure tests", () {
      test("unsuccessful http response returns Error", () async {
        when(
          httpClient.getAsString(any, headers: anyNamed("headers")),
        ).thenAnswer((_) async => HttpGetUnsuccessfulResponse(""));

        final result = await dataSource.getArticles();

        expect(result, Error<List<MyArticle>>());

        verify(
          httpClient.getAsString(
            zappingUrl,
            headers: argThat(equals({"user-agent": ""}), named: "headers"),
          ),
        ).called(1);

        verifyNoMoreInteractions(httpClient);
        verifyZeroInteractions(rssParser);
      });

      test("unsuccessful parser response returns Error", () async {
        when(
          httpClient.getAsString(any, headers: anyNamed("headers")),
        ).thenAnswer((_) async => httpSuccess);
        when(rssParser.parse(any)).thenAnswer((realInvocation) => RssParseException(Exception()));

        final result = await dataSource.getArticles();

        expect(result, Error<List<MyArticle>>());

        verifyBothFunctionsCalled(httpSuccess.bodyAsString);
      });

      test("exception in the http client returns Error", () async {
        when(httpClient.getAsString(any, headers: anyNamed("headers"))).thenThrow(Exception());

        final result = await dataSource.getArticles();

        expect(result, Error<List<MyArticle>>());

        verify(
          httpClient.getAsString(
            zappingUrl,
            headers: argThat(equals({"user-agent": ""}), named: "headers"),
          ),
        ).called(1);

        verifyNoMoreInteractions(httpClient);
        verifyZeroInteractions(rssParser);
      });

      test("exception in the parser returns Error", () async {
        when(
          httpClient.getAsString(any, headers: anyNamed("headers")),
        ).thenAnswer((_) async => httpSuccess);
        when(rssParser.parse(any)).thenThrow(Exception());

        final result = await dataSource.getArticles();

        expect(result, Error<List<MyArticle>>());

        verifyBothFunctionsCalled(httpSuccess.bodyAsString);
      });

      test("exception when parsing a date ignores that match", () async {
        when(
          httpClient.getAsString(any, headers: anyNamed("headers")),
        ).thenAnswer((_) async => httpSuccess);

        // some dates here are not in the format that we expect
        const List<MyRssItem> parserOutputWrongDate = [
          MyRssItem(
            title: "Al Hilal x Al-Ettifaq - 08/11 14:45 - SportTV 1",
            // this date is wrong, the seconds are missing
            pubDate: "Fri, 08 Nov 2024 14:45",
          ),
          MyRssItem(
            title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1",
            pubDate: "Fri, 08 Nov 2024 17:00:00",
          ),
          MyRssItem(
            title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +",
            pubDate: "Fri, 08 Nov 2024 18:00:00",
          ),
        ];
        when(rssParser.parse(any)).thenReturn(RssParseSuccess(parserOutputWrongDate));

        final result = await dataSource.getArticles();

        // we expect the first rssItem above to not be successfully parsed
        final expectedResult = Success([
          MyArticle(
            title: "Al-Riyadh x Al Nassr - 08/11 17:00 - SportTV 1",
            date: DateTime(2024, 11, 8, 17),
          ),
          MyArticle(
            title: "FC Vizela x GD Chaves - 08/11 18:00 - SportTV +",
            date: DateTime(2024, 11, 8, 18),
          ),
        ]);

        expect(result, expectedResult);

        verifyBothFunctionsCalled(httpSuccess.bodyAsString);
      });
    });
  });
}
