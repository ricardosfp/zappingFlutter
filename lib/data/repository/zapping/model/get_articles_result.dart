import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';

part 'get_articles_result.g.dart';

sealed class GetArticlesResult extends Equatable {
  const GetArticlesResult();
}

@autoequal
class GetArticlesSuccess extends GetArticlesResult {
  final IList<MyArticle> articles;

  GetArticlesSuccess(List<MyArticle> articles) : articles = IList(articles);

  @override
  List<Object?> get props => _$props;
}

sealed class GetArticlesError extends GetArticlesResult {
  const GetArticlesError();
}

@autoequal
final class GetArticlesHttpError extends GetArticlesError {
  @override
  List<Object?> get props => _$props;
}

@autoequal
final class GetArticlesParseError extends GetArticlesError {
  @override
  List<Object?> get props => _$props;
}

@autoequal
final class GetArticlesOtherExceptionError extends GetArticlesError {
  final Exception exception;

  const GetArticlesOtherExceptionError(this.exception);

  @override
  List<Object?> get props => _$props;
}
