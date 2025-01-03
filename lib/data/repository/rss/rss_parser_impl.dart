import 'package:dart_rss/dart_rss.dart';
import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parse_result.dart';
import 'package:zapping_flutter/data/repository/rss/rss_parser.dart';
import 'package:zapping_flutter/data/repository/rss/my_rss_item.dart';

// todo test the rss parser
@LazySingleton(as: RssParser)
final class RssParserImpl implements RssParser {
  @override
  RssParseResult parse(String rssText) {
    try {
      final rssFeed = RssFeed.parse(rssText);

      final myRssItems = rssFeed.items
          .map((rssItem) {
            final title = rssItem.title;
            final pubDate = rssItem.pubDate;

            if (title != null && pubDate != null) {
              return MyRssItem(title: title, pubDate: pubDate);
            }
          })
          .nonNulls
          .toList();

      return RssParseSuccess(myRssItems);
    } on Exception catch (ex) {
      return RssParseException(ex);
    }
  }
}
