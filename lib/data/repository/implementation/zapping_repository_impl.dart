import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/repository/contract/rss_parser.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/data/repository/model/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';
import 'package:zapping_flutter/data/repository/model/rss_parse_result.dart';
import 'package:zapping_flutter/di/di.dart';

@LazySingleton(as: ZappingRepository)
final class ZappingRepositoryImpl implements ZappingRepository {
  // todo abstract this to facilitate testing
  final HttpWithMiddleware _http;
  final RssParser _rssParser;

  ZappingRepositoryImpl({HttpWithMiddleware? http, RssParser? rssParser})
      : _http = http ?? getIt<HttpWithMiddleware>(),
        _rssParser = rssParser ?? getIt<RssParser>();

// todo test
  @override
  Future<GetArticlesResult> getArticles(String url) async {
    try {
      // I am using http because dio was not correctly decoding accents
      // the user-agent part is because the website was giving us error 429 with the default user-agent
      final response =
          await _http.get(Uri.parse(url), headers: {"user-agent": ""});

      final rssParseResult = _rssParser.parse(response.body);

      switch (rssParseResult) {
        case RssParseSuccess():
          return GetArticlesSuccess(List.unmodifiable(
            rssParseResult.items.map((item) {
              return MyArticle(title: item.title, date: item.pubDate);
            }),
          ));
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
