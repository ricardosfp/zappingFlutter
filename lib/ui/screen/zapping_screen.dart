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
          final uiState = zappingProvider.uiState;

          // todo check switch as expression
          switch (uiState) {
            case UiDataReady():
              final tabs = uiState.dayMap.keys.map((matchDay) {
                return Tab(text: _tabDateFormat.format(matchDay));
              }).toList();

              final zappingDays = uiState.dayMap.values.map((matchList) {
                return ZappingDay(matches: matchList);
              }).toList();

              return DefaultTabController(
                length: uiState.dayMap.length,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: _provideAppBarTitle(),
                    actions: _provideAppBarActions(),
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
            case UiLoading():
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: _provideAppBarTitle(),
                  actions: _provideAppBarActions(),
                ),
                body: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.25,
                    height: MediaQuery.sizeOf(context).width * 0.25,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                    ),
                  ),
                ),
              );
            case UiError():
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: _provideAppBarTitle(),
                    actions: _provideAppBarActions(),
                  ),
                  body: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      child: Text(
                        "Could not load data, try again later",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ));
          }
        },
      ),
    );
  }

  static Text _provideAppBarTitle() {
    return const Text(
      "Zapping",
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),
    );
  }

  List<Widget> _provideAppBarActions() {
    return [
      IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.black,
          ),
          onPressed: () {
            _zappingProvider.getMatches();
          })
    ];
  }
}
