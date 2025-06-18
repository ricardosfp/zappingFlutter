import 'package:zapping_flutter/data/services/rss/model/rss_parse_result.dart';

abstract interface class RssParser {
  RssParseResult parse(String rssText);
}
