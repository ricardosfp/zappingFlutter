import 'package:dart_rss/dart_rss.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/contract/rss_parser.dart';
import 'package:zapping_flutter/data/repository/model/my_rss_item.dart';
import 'package:zapping_flutter/data/repository/model/rss_parse_result.dart';

// todo test the rss parser
@LazySingleton(as: RssParser)
final class RssParserImpl implements RssParser {
  @override
  RssParseResult parse(String rssText) {
    try {
      final rssFeed = RssFeed.parse(rssText);

      final myRssItems = rssFeed.items.where((rssItem) {
        return rssItem.title != null && rssItem.pubDate != null;
      }).map((rssItem) {
        return MyRssItem(title: rssItem.title!, pubDate: rssItem.pubDate!);
      }).toList();

      return RssParseSuccess(myRssItems);
    } on Exception catch (ex) {
      return RssParseException(ex);
    }
  }
}
