import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';

part 'my_article.g.dart';

@generateProps
final class MyArticle extends Equatable {
  final String title;
  final String date;

  const MyArticle({required this.title, required this.date});

  @override
  List<Object?> get props => _$props;
}
