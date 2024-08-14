import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';
import 'package:zapping_flutter/data/repository/contract/zapping_repository.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';

final class ZappingRepositoryImpl implements ZappingRepository {
  late final _dio = Dio();

  // todo handle exceptions
  @override
  Future<List<MyArticle>> getMatches(String url) async {
    // the user-agent part is because ZeroZero was giving us error 429 with the default user-agent
    final response = await _dio.get(url,
        options: Options(
          headers: {"user-agent": ""},
        ));

    final rssFeed = RssFeed.parse(response.data.toString());

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
