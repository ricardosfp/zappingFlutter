import 'package:intl/intl.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';
import 'package:zapping_flutter/domain/match/match_parser.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';

// todo test
final class MatchParserImpl implements MatchParser {
  static final _dateFormat = DateFormat("E, d MMM yyyy HH:mm:ss");

  // todo handle errors
  @override
  MyMatch? parse(MyArticle article) {
    try {
      final date = _dateFormat.parse(article.date);
      final originalText = article.title;

      final parts = originalText.split(" - ");
      if (parts.length == 3) {
        final teams = parts[0].split(" x ");
        if (teams.length == 2) {
          final homeTeam = teams[0];
          final awayTeam = teams[1];
          final channel = parts[2];

          if (homeTeam.isEmpty || awayTeam.isEmpty || channel.isEmpty) {
            return null;
          } else {
            return MyMatch(homeTeam, awayTeam, date, channel, originalText);
          }
        }
      }
    } finally {}

    return null;
  }
}
