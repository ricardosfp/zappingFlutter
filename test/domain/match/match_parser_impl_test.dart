import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/domain/match/match_parser_impl.dart';
import 'package:zapping_flutter/domain/match/model/match_parse_result.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

void main() {
  late MatchParserImpl matchParser;

  //    "Peñarol x Atlético Mineiro - 14/05 23:00 - SportTv1"
  const validArticleDateString = "Tue, 14 May 2024 23:00:00";
  const validArticleHomeTeam = "Peñarol";
  const validArticleAwayTeam = "Atlético Mineiro";
  const validArticleChannel = "SportTv1";
  const validArticleTitle = "$validArticleHomeTeam x $validArticleAwayTeam - 14/05 23:00 - $validArticleChannel";
  const validArticle = MyArticle(title: validArticleTitle, date: validArticleDateString);

  final matchParseSuccess = MatchParseSuccess(
    MyMatch(
      homeTeam: validArticleHomeTeam,
      awayTeam: validArticleAwayTeam,
      date: DateTime(2024, 5, 14, 23, 0, 0),
      channel: validArticleChannel,
      originalText: validArticleTitle,
    ),
  );

  // invalid articles
  const invalidArticleInvalidDate = MyArticle(title: validArticleTitle, date: "14 May 24");
  const invalidArticleInvalidHomeTeam =
      MyArticle(title: " x Atlético Mineiro - 14/05 23:00 - SportTv1", date: validArticleDateString);
  const invalidArticleInvalidAwayTeam =
      MyArticle(title: "Peñarol x  - 14/05 23:00 - SportTv1", date: validArticleDateString);
  const invalidArticleInvalidChannel =
      MyArticle(title: "Peñarol x Atlético Mineiro - 14/05 23:00 - ", date: validArticleDateString);

  setUp(() {
    matchParser = MatchParserImpl();
  });

  test("parse valid article returns success", () {
    final matchParseResult = matchParser.parse(validArticle);

    expect(matchParseResult, matchParseSuccess);
  });

  group("failure tests", () {
    test("parse invalid date returns date error", () {
      final matchParseResult = matchParser.parse(invalidArticleInvalidDate);

      expect(matchParseResult, isA<MatchParseDateError>());
    });

    test("parse invalid home team returns title error", () {
      final matchParseResult = matchParser.parse(invalidArticleInvalidHomeTeam);

      expect(matchParseResult, MatchParseTitleError());
    });

    test("parse invalid away team returns title error", () {
      final matchParseResult = matchParser.parse(invalidArticleInvalidAwayTeam);

      expect(matchParseResult, MatchParseTitleError());
    });

    test("parse invalid channel returns title error", () {
      final matchParseResult = matchParser.parse(invalidArticleInvalidChannel);

      expect(matchParseResult, MatchParseTitleError());
    });
  });
}
