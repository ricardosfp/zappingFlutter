import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:zapping_flutter/data/repository/zapping/data_source/remote/zapping_data_source_remote.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/data/services/http_client/model/http_get_result.dart';
import 'package:zapping_flutter/data/services/http_client/my_http_client.dart';
import 'package:zapping_flutter/data/services/rss/model/rss_parse_result.dart';
import 'package:zapping_flutter/data/services/rss/rss_parser.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';
import 'package:zapping_flutter/infrastructure/result.dart';

@Injectable(as: ZappingDataSourceRemote)
final class ZappingDataSourceRemoteNetwork implements ZappingDataSourceRemote {
  final MyHttpClient _httpClient;
  final RssParser _rssParser;
  final String _zappingUrl;

  ZappingDataSourceRemoteNetwork(
    this._httpClient,
    this._rssParser,
    @Named(DiName.zappingUrl) this._zappingUrl,
  );

  static final _dateFormat = DateFormat("EEE, d MMM yyyy HH:mm:ss");

  @override
  Future<Result<List<MyArticle>>> getArticles() async {
    try {
      // the user-agent part is because the website was giving us error 429 with the default user-agent
      final httpGetResult = await _httpClient.getAsString(_zappingUrl, headers: {"user-agent": ""});

      switch (httpGetResult) {
        case HttpGetSuccess():
          final rssParseResult = _rssParser.parse(httpGetResult.bodyAsString);

          switch (rssParseResult) {
            case RssParseSuccess():
              return Success(
                rssParseResult.items
                    .map((item) {
                      try {
                        // there might be an exception in date parsing
                        return MyArticle(title: item.title, date: _dateFormat.parse(item.pubDate));
                      } catch (_) {
                        return null;
                      }
                    })
                    .nonNulls
                    .toList(),
              );

            case RssParseError():
              return Error();
          }
        case HttpGetError():
          return Error();
      }
    } catch (ex) {
      return Error();
    }
  }
}
