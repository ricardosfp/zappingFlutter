import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/model/my_article.dart';
import 'package:zapping_flutter/domain/match/match_parse_result.dart';
import 'package:zapping_flutter/domain/match/match_parser_impl.dart';

void main() {
  late MatchParserImpl matchParser;

  //    "Peñarol x Atlético Mineiro - 14/05 23:00 - SportTv1"
  const validArticleDateString = "Tue, 14 May 2024 23:00:00";
  const validArticleHomeTeam = "Peñarol";
  const validArticleAwayTeam = "Atlético Mineiro";
  const validArticleChannel = "SportTv1";
  const validArticleTitle =
      "$validArticleHomeTeam x $validArticleAwayTeam - 14/05 23:00 - $validArticleChannel";
  const validArticle = MyArticle(validArticleDateString, validArticleTitle);

  setUp(() {
    matchParser = MatchParserImpl();
  });

  test("parse valid article returns success", () {
    final matchParseResult = matchParser.parse(validArticle);

    expect(matchParseResult, isA<MatchParseSuccess>());

    final match = (matchParseResult as MatchParseSuccess).match;

    expect(match.originalText, validArticleTitle);
    expect(match.homeTeam, validArticleHomeTeam);
    expect(match.awayTeam, validArticleAwayTeam);
    expect(match.date, DateTime(2024, 5, 14, 23, 0, 0));
    expect(match.channel, validArticleChannel);
    expect(match.originalText, validArticleTitle);
  });
}
