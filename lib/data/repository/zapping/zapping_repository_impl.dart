import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/zapping/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository.dart';
import 'package:zapping_flutter/data/services/http_client/model/http_get_result.dart';
import 'package:zapping_flutter/data/services/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/services/rss/model/rss_parse_result.dart';
import 'package:zapping_flutter/data/services/rss/rss_parser.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';

@LazySingleton(as: ZappingRepository)
final class ZappingRepositoryImpl implements ZappingRepository {
  // todo use data sources
  final MyHttpClient _http;
  final RssParser _rssParser;

  ZappingRepositoryImpl({MyHttpClient? http, RssParser? rssParser})
    : _http = http ?? getIt<MyHttpClient>(),
      _rssParser = rssParser ?? getIt<RssParser>();

  @override
  Future<GetArticlesResult> getArticles(String url) async {
    try {
      // the user-agent part is because the website was giving us error 429 with the default user-agent
      final httpGetResult = await _http.getAsString(url, headers: {"user-agent": ""});

      switch (httpGetResult) {
        case HttpGetSuccess():
          final rssParseResult = _rssParser.parse(httpGetResult.bodyAsString);

          switch (rssParseResult) {
            case RssParseSuccess():
              return GetArticlesSuccess(
                rssParseResult.items.map((item) {
                  return MyArticle(title: item.title, date: item.pubDate);
                }).toList(),
              );

            case RssParseError():
              return GetArticlesParseError();
          }
        case HttpGetError():
          return GetArticlesHttpError();
      }
    } on Exception catch (ex) {
      return GetArticlesOtherExceptionError(ex);
    }
  }
}
