import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';

part 'my_match.g.dart';

// this class is called [MyMatch] to not be confused with [Match]
@generateProps
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
