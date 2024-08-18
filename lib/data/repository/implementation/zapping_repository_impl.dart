import 'package:dart_rss/dart_rss.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';

final class ZappingRepositoryImpl implements ZappingRepository {
  late final http = HttpWithMiddleware.build(
      middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);

  // todo handle exceptions
  @override
  Future<List<MyArticle>> getMatches(String url) async {
    // I am using http because dio was not correctly decoding accents
    // the user-agent part is because the website was giving us error 429 with the default user-agent
    final response =
        await http.get(Uri.parse(url), headers: {"user-agent": ""});

    final rssFeed = RssFeed.parse(response.body);

    final rssItems = rssFeed.items.where((item) {
      return item.pubDate != null && item.title != null;
    });

    return List<MyArticle>.unmodifiable(
      rssItems.map((item) {
        return MyArticle(item.pubDate!, item.title!);
      }),
    );
  }
}
