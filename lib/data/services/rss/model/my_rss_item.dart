import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';

part 'my_rss_item.g.dart';

@generateProps
final class MyRssItem extends Equatable {
  final String title;
  final String pubDate;

  const MyRssItem({required this.title, required this.pubDate});

  @override
  List<Object?> get props => _$props;
}
