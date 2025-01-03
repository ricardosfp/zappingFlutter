/// This class is called [MyMatch] to not be confused with [Match]
final class MyMatch {
  final String homeTeam;
  final String awayTeam;
  final DateTime date;
  final String channel;
  final String originalText;

  const MyMatch(
      this.homeTeam, this.awayTeam, this.date, this.channel, this.originalText);

  @override
  String toString() {
    return 'MyMatch{homeTeam: $homeTeam, awayTeam: $awayTeam, date: $date, channel: $channel, originalText: $originalText}';
  }
}
