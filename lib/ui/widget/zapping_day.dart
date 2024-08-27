import 'package:flutter/material.dart';
import 'package:zapping_flutter/domain/model/my_match.dart';
import 'package:zapping_flutter/ui/widget/zapping_item.dart';

class ZappingDay extends StatelessWidget {
  final List<MyMatch> _matches;

  const ZappingDay({super.key, required List<MyMatch> matches})
      : _matches = matches;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemCount: _matches.length,
        itemBuilder: (context, index) {
          final match = _matches[index];

          return Container(
            margin: const EdgeInsets.only(left: 10),
            child: ZappingItem(match: match),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 30);
        },
      ),
    );
  }
}
