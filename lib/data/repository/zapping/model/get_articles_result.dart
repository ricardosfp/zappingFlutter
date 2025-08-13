import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';

part 'get_articles_result.g.dart';

sealed class GetArticlesResult extends Equatable {
  const GetArticlesResult();
}

@generateProps
final class GetArticlesSuccess extends GetArticlesResult {
  final IList<MyArticle> articles;

  GetArticlesSuccess(List<MyArticle> articles) : articles = IList(articles);

  @override
  List<Object?> get props => _$props;
}

@generateProps
final class GetArticlesError extends GetArticlesResult {
  const GetArticlesError();

  @override
  List<Object?> get props => _$props;
}
