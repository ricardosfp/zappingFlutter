import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';

class ZappingItem extends StatelessWidget {
  final MyMatch _match;

  static final _dateFormat = DateFormat("HH:mm");

  static const _textStyle = TextStyle(color: Color(0xff000000), fontSize: 16);

  const ZappingItem({super.key, required MyMatch match}) : _match = match;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_match.homeTeam} x ${_match.awayTeam}",
          style: _textStyle,
        ),
        Text(
          _dateFormat.format(_match.date),
          style: _textStyle,
        ),
        Text(
          _match.channel,
          style: _textStyle,
        ),
      ],
    );
  }
}
