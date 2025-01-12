import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/data/repository/rss/model/my_rss_item.dart';

sealed class RssParseResult {}

final class RssParseSuccess implements RssParseResult {
  final IList<MyRssItem> items;

  RssParseSuccess(Iterable<MyRssItem> items) : items = IList(items);
}

sealed class RssParseError extends RssParseResult {}

final class RssParseException implements RssParseError {
  final Exception exception;

  const RssParseException(this.exception);
}
