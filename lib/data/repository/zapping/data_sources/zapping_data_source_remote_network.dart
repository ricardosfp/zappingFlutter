import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/repository/zapping/data_sources/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/services/http_client/model/http_get_result.dart';
import 'package:zapping_flutter/data/services/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/services/rss/model/rss_parse_result.dart';
import 'package:zapping_flutter/data/services/rss/rss_parser.dart';
import 'package:zapping_flutter/infrastructure/result.dart';
import 'package:zapping_flutter/main.dart';

@Injectable(as: ZappingDataSourceRemote)
final class ZappingDataSourceRemoteNetwork implements ZappingDataSourceRemote {
  final MyHttpClient _http;
  final RssParser _rssParser;

  ZappingDataSourceRemoteNetwork(this._http, this._rssParser);

  @override
  Future<Result<List<MyArticle>>> getArticles() async {
    try {
      // the user-agent part is because the website was giving us error 429 with the default user-agent
      final httpGetResult = await _http.getAsString(zappingUrl, headers: {"user-agent": ""});

      switch (httpGetResult) {
        case HttpGetSuccess():
          final rssParseResult = _rssParser.parse(httpGetResult.bodyAsString);

          switch (rssParseResult) {
            case RssParseSuccess():
              return Success(
                rssParseResult.items.map((item) {
                  return MyArticle(title: item.title, date: item.pubDate);
                }).toList(),
              );

            case RssParseError():
              return Error();
          }
        case HttpGetError():
          return Error();
      }
    } catch (_, _) {
      return Error();
    }
  }
}
