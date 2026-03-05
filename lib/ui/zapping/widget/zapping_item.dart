import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';

class ZappingItem extends StatelessWidget {
  final MyMatch _match;

  const ZappingItem({super.key, required MyMatch match}) : _match = match;

  static final _dateFormat = DateFormat("HH:mm");
  static const _textStyle = TextStyle(color: Color(0xff000000), fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${_match.homeTeam} x ${_match.awayTeam}", style: _textStyle),
          Text(_dateFormat.format(_match.date), style: _textStyle),
          Text(_match.channel, style: _textStyle),
        ],
      ),
    );
  }
}
