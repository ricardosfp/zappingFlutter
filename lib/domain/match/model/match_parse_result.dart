import 'package:zapping_flutter/domain/match/model/my_match.dart';

sealed class MatchParseResult {}

class MatchParseSuccess implements MatchParseResult {
  final MyMatch match;

  const MatchParseSuccess(this.match);
}

sealed class MatchParseError extends MatchParseResult {}

class MatchParseDateError implements MatchParseError {
  final FormatException exception;

  const MatchParseDateError(this.exception);
}

class MatchParseTitleError implements MatchParseError {}

class MatchParseOtherExceptionError implements MatchParseError {
  final Exception exception;

  const MatchParseOtherExceptionError(this.exception);
}
