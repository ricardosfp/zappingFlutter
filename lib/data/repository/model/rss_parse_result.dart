import 'package:zapping_flutter/data/repository/model/my_rss_item.dart';

sealed class RssParseResult {}

final class RssParseSuccess implements RssParseResult {
  final List<MyRssItem> items;

  RssParseSuccess(this.items);
}

sealed class RssParseError extends RssParseResult {}

final class RssParseException implements RssParseError {
  final Exception exception;

  RssParseException(this.exception);
}
