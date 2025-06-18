import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';

part 'my_match.g.dart';

// this class is called [MyMatch] to not be confused with [Match]
@autoequal
final class MyMatch extends Equatable {
  final String homeTeam;
  final String awayTeam;
  final DateTime date;
  final String channel;
  final String originalText;

  const MyMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.channel,
    required this.originalText,
  });

  @override
  List<Object?> get props => _$props;
}
