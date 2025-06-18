import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

part 'match_parse_result.g.dart';

sealed class MatchParseResult extends Equatable {
  const MatchParseResult();
}

@autoequal
final class MatchParseSuccess extends MatchParseResult {
  final MyMatch match;

  const MatchParseSuccess(this.match);

  @override
  List<Object?> get props => _$props;
}

sealed class MatchParseError extends MatchParseResult {
  const MatchParseError();
}

@autoequal
final class MatchParseDateError extends MatchParseError {
  final FormatException exception;

  const MatchParseDateError(this.exception);

  @override
  List<Object?> get props => _$props;
}

@autoequal
final class MatchParseTitleError extends MatchParseError {
  @override
  List<Object?> get props => _$props;
}

@autoequal
final class MatchParseOtherExceptionError extends MatchParseError {
  final Exception exception;

  const MatchParseOtherExceptionError(this.exception);

  @override
  List<Object?> get props => _$props;
}
