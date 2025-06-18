import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/data/services/rss/model/my_rss_item.dart';

part 'rss_parse_result.g.dart';

sealed class RssParseResult extends Equatable {
  const RssParseResult();
}

@autoequal
final class RssParseSuccess extends RssParseResult {
  final IList<MyRssItem> items;

  RssParseSuccess(List<MyRssItem> items) : items = IList(items);

  @override
  List<Object?> get props => _$props;
}

sealed class RssParseError extends RssParseResult {
  const RssParseError();
}

@autoequal
final class RssParseException extends RssParseError {
  final Exception exception;

  const RssParseException(this.exception);

  @override
  List<Object?> get props => _$props;
}
