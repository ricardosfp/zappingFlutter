import 'package:test/test.dart';
import 'package:zapping_flutter/data/repository/zapping/model/my_article.dart';
import 'package:zapping_flutter/domain/match/match_parser_impl.dart';
import 'package:zapping_flutter/domain/match/model/match_parse_result.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

void main() {
  late MatchParserImpl matchParser;

  //    "Peñarol x Atlético Mineiro - 14/05 23:00 - SportTv1"
  final validArticleDate = DateTime(2024, 5, 14, 23);
  const validArticleHomeTeam = "Peñarol";
  const validArticleAwayTeam = "Atlético Mineiro";
  const validArticleChannel = "SportTv1";
  const validArticleTitle =
      "$validArticleHomeTeam x $validArticleAwayTeam - 14/05 23:00 - $validArticleChannel";
  final validArticle = MyArticle(title: validArticleTitle, date: validArticleDate);

  final matchParseSuccess = MatchParseSuccess(
    MyMatch(
      homeTeam: validArticleHomeTeam,
      awayTeam: validArticleAwayTeam,
      date: validArticleDate,
      channel: validArticleChannel,
      originalText: validArticleTitle,
    ),
  );

  // invalid articles
  final invalidArticleInvalidHomeTeam = MyArticle(
    title: " x Atlético Mineiro - 14/05 23:00 - SportTv1",
    date: validArticleDate,
  );
  final invalidArticleInvalidAwayTeam = MyArticle(
    title: "Peñarol x  - 14/05 23:00 - SportTv1",
    date: validArticleDate,
  );
  final invalidArticleInvalidChannel = MyArticle(
    title: "Peñarol x Atlético Mineiro - 14/05 23:00 - ",
    date: validArticleDate,
  );

  setUp(() {
    matchParser = MatchParserImpl();
  });

  test("parse valid article returns success", () {
    final matchParseResult = matchParser.parse(validArticle);

    expect(matchParseResult, matchParseSuccess);
  });

  group("failure tests", () {
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
