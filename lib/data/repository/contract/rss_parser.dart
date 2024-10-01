import 'package:zapping_flutter/data/repository/model/rss_parse_result.dart';

abstract interface class RssParser {
  RssParseResult parse(String rssText);
}
