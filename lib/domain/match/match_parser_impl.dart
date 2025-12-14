import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/domain/match/match_parser.dart';
import 'package:zapping_flutter/domain/match/model/match_parse_result.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

@LazySingleton(as: MatchParser)
final class MatchParserImpl implements MatchParser {
  @override
  MatchParseResult parse(MyArticle article) {
    try {
      final originalText = article.title;

      final parts = originalText.split(" - ");
      if (parts.length == 3) {
        final teams = parts[0].split(" x ");
        if (teams.length == 2) {
          final homeTeam = teams[0];
          final awayTeam = teams[1];
          final channel = parts[2];

          if (homeTeam.isEmpty || awayTeam.isEmpty || channel.isEmpty) {
            return MatchParseTitleError();
          } else {
            return MatchParseSuccess(
              MyMatch(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                date: article.date,
                channel: channel,
                originalText: originalText,
              ),
            );
          }
        } else {
          return MatchParseTitleError();
        }
      } else {
        return MatchParseTitleError();
      }
    } catch (ex) {
      return MatchParseOtherExceptionError(ex);
    }
  }
}
