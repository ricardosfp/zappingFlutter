import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/repository/contract/get_articles_result.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';

@LazySingleton(as: ZappingRepository)
final class ZappingRepositoryImpl implements ZappingRepository {
  late final _http = HttpWithMiddleware.build(
      middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);

  // todo handle exceptions
  @override
  Future<GetArticlesResult> getArticles(String url) async {
    try {
      // I am using http because dio was not correctly decoding accents
      // the user-agent part is because the website was giving us error 429 with the default user-agent
      final response =
          await _http.get(Uri.parse(url), headers: {"user-agent": ""});

      // this can throw ArgumentError
      final rssFeed = RssFeed.parse(response.body);

      final rssItems = rssFeed.items.where((item) {
        return item.pubDate != null && item.title != null;
      });

      return GetArticlesSuccess(List.unmodifiable(
        rssItems.map((item) {
          return MyArticle(item.pubDate!, item.title!);
        }),
      ));
    } on ClientException catch (ex) {
      return GetArticlesHttpError(ex);
    } on ArgumentError catch (ex) {
      return GetArticlesParseError(ex);
    } on Exception catch (ex) {
      return GetArticlesOtherExceptionError(ex);
    }
  }
}
