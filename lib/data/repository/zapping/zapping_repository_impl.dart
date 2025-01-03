import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parse_result.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parser.dart';
import 'package:zapping_flutter/data/repository/zapping/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/zapping/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/zapping_repository.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';

@LazySingleton(as: ZappingRepository)
final class ZappingRepositoryImpl implements ZappingRepository {
  final MyHttpClient _http;
  final RssParser _rssParser;

  ZappingRepositoryImpl({MyHttpClient? http, RssParser? rssParser})
      : _http = http ?? getIt<MyHttpClient>(),
        _rssParser = rssParser ?? getIt<RssParser>();

  @override
  Future<GetArticlesResult> getArticles(String url) async {
    try {
      // the user-agent part is because the website was giving us error 429 with the default user-agent
      // todo this could get a string
      final response = await _http.get(url, headers: {"user-agent": ""});

      final rssParseResult = _rssParser.parse(response.body);

      switch (rssParseResult) {
        case RssParseSuccess():
          return GetArticlesSuccess(
            rssParseResult.items.map((item) {
              return MyArticle(title: item.title, date: item.pubDate);
            }).toList(),
          );
        case RssParseException():
          return GetArticlesParseError(rssParseResult.exception);
      }
    } on ClientException catch (ex) {
      return GetArticlesHttpError(ex);
    } on Exception catch (ex) {
      return GetArticlesOtherExceptionError(ex);
    }
  }
}
