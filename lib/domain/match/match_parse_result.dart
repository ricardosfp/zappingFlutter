import 'package:zapping_flutter/domain/model/my_match.dart';

sealed class MatchParseResult {}

//region success

class MatchParseSuccess implements MatchParseResult {
  final MyMatch match;

  MatchParseSuccess(this.match);
}

//endregion success

//region error

sealed class MatchParseError extends MatchParseResult {}

class MatchParseDateError implements MatchParseError {
  final FormatException exception;

  MatchParseDateError(this.exception);
}

class MatchParseTitleError implements MatchParseError {}

class MatchParseExceptionError implements MatchParseError {
  final Exception exception;

  MatchParseExceptionError(this.exception);
}

class MatchParseUnknownError implements MatchParseError {}

//endregion error
