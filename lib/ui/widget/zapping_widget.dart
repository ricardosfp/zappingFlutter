import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zapping_flutter/ui/view_model/zapping_provider.dart';

class ZappingWidget extends StatefulWidget {
  const ZappingWidget({super.key});

  @override
  State<ZappingWidget> createState() => _ZappingWidgetState();
}

class _ZappingWidgetState extends State<ZappingWidget> {
  // todo inject this
  late final _zappingProvider = ZappingProvider();

  late final _dateFormat = DateFormat("HH:mm");

  late final _textStyle =
      const TextStyle(color: Color(0xff000000), fontSize: 16);

  @override
  void initState() {
    super.initState();
    _zappingProvider.getMatches();
  }

  // todo extract the item into a new widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Zapping"),
        ),
        body: ChangeNotifierProvider.value(
          value: _zappingProvider,
          child: Consumer<ZappingProvider>(
            builder: (context, zappingProvider, Widget? child) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.separated(
                  itemCount: zappingProvider.matches.length,
                  itemBuilder: (context, index) {
                    final match = zappingProvider.matches[index];

                    return Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${match.homeTeam} x ${match.awayTeam}",
                              style: _textStyle),
                          Text(_dateFormat.format(match.date),
                              style: _textStyle),
                          Text(match.channel, style: _textStyle),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 30);
                  },
                ),
              );
            },
          ),
        ));
  }
}
