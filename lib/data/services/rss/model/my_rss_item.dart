import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';

part 'my_rss_item.g.dart';

@autoequal
final class MyRssItem extends Equatable {
  final String title;
  final String pubDate;

  const MyRssItem({required this.title, required this.pubDate});

  @override
  List<Object?> get props => _$props;
}
