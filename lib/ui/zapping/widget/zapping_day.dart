import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';
import 'package:zapping_flutter/ui/zapping/widget/zapping_item.dart';

class ZappingDay extends StatelessWidget {
  final IList<MyMatch> _matches;

  const ZappingDay({super.key, required IList<MyMatch> matches}) : _matches = matches;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemCount: _matches.length,
        itemBuilder: (context, index) {
          final match = _matches[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
