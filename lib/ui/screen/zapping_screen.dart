import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/ui/view_model/zapping_provider.dart';
import 'package:zapping_flutter/ui/widget/zapping_day.dart';

class ZappingScreen extends StatefulWidget {
  const ZappingScreen({super.key});

  @override
  State<ZappingScreen> createState() => _ZappingScreenState();
}

class _ZappingScreenState extends State<ZappingScreen> {
  late final _zappingProvider = getIt<ZappingProvider>();

  static final _tabDateFormat = DateFormat("EEEE d");

  @override
  void initState() {
    super.initState();
    _zappingProvider.getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _zappingProvider,
      child: Consumer<ZappingProvider>(
        builder: (context, zappingProvider, Widget? child) {
          final matchMap = zappingProvider.matchMap;

          final tabs = matchMap.keys.map(
            (matchDay) {
              return Tab(text: _tabDateFormat.format(matchDay));
            },
          ).toList();

          final zappingDays = matchMap.values.map(
            (matchList) {
              return ZappingDay(matches: matchList);
            },
          ).toList();

          return DefaultTabController(
            length: matchMap.length,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text("Zapping"),
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  tabs: tabs,
                  isScrollable: true,
                ),
              ),
              body: TabBarView(
                children: zappingDays,
              ),
            ),
          );
        },
      ),
    );
  }
}
