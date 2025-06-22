import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zapping_flutter/domain/match/model/my_match.dart';
import 'package:zapping_flutter/infrastructure/di/di.dart';
import 'package:zapping_flutter/ui/zapping/view_model/model/filter_result.dart';
import 'package:zapping_flutter/ui/zapping/view_model/model/ui_state.dart';
import 'package:zapping_flutter/ui/zapping/view_model/zapping_provider.dart';
import 'package:zapping_flutter/ui/zapping/widget/zapping_day.dart';

class ZappingScreen extends StatefulWidget {
  final ZappingProvider _zappingProvider;

  ZappingScreen({super.key, ZappingProvider? zappingProvider})
    : _zappingProvider = zappingProvider ?? getIt<ZappingProvider>();

  @override
  State<ZappingScreen> createState() => _ZappingScreenState();
}

class _ZappingScreenState extends State<ZappingScreen> {
  late final _zappingProvider = widget._zappingProvider;
  late final _controller = TextEditingController();
  static final _tabDateFormat = DateFormat("EEEE d");

  bool _searchMode = false;

  @override
  void initState() {
    super.initState();
    _zappingProvider.getMatches();
    _controller.addListener(() {
      // reload the list with the new filter
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _zappingProvider,
      child: Consumer<ZappingProvider>(
        builder: (context, zappingProvider, Widget? child) {
          final uiState = zappingProvider.uiState;

          switch (uiState) {
            case UiIdle():
            case UiLoading():
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: _provideAppBarTitle(uiState),
                  actions: _provideAppBarActions(uiState),
                ),
                body: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.25,
                    height: MediaQuery.sizeOf(context).width * 0.25,
                    child: CircularProgressIndicator(strokeWidth: 8),
                  ),
                ),
              );
            case UiDataReady():
              late final IMap<DateTime, IList<MyMatch>> finalMap;

              if (_searchMode && _controller.text.isNotEmpty) {
                final filterResult = _zappingProvider.filterList(_controller.text);

                finalMap = switch (filterResult) {
                  FilterSuccess() => filterResult.filteredMap,
                  _ => uiState.dayMap,
                };
              } else {
                finalMap = uiState.dayMap;
              }

              final tabs = finalMap.keys.map((matchDay) {
                return Tab(text: _tabDateFormat.format(matchDay));
              }).toList();

              final zappingDays = finalMap.values.map((matchList) {
                return ZappingDay(matches: matchList);
              }).toList();

              return DefaultTabController(
                length: finalMap.length,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    title: _provideAppBarTitle(uiState),
                    actions: _provideAppBarActions(uiState),
                    bottom: TabBar(
                      tabAlignment: TabAlignment.center,
                      tabs: tabs,
                      isScrollable: true,
                    ),
                  ),
                  body: TabBarView(children: zappingDays),
                ),
              );
            case UiError():
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: _provideAppBarTitle(uiState),
                  actions: _provideAppBarActions(uiState),
                ),
                body: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Could not load data, try again later",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  // todo test this and the function below in widget tests
  Widget _provideAppBarTitle(UiState uiState) {
    return _searchMode && uiState is UiDataReady
        ? TextField(
            controller: _controller,
            autofocus: true,
            // to show letters and numbers
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.search,
            style: TextStyle(color: Colors.black, fontSize: 22),
          )
        : const Text("Zapping", style: TextStyle(color: Colors.black, fontSize: 22));
  }

  // only show search icon and allow search mode when the data is ready
  // todo what happens if I close the search bar and open it again? Does it still show the same text?
  List<Widget> _provideAppBarActions(UiState uiState) {
    return [
      if (_searchMode && uiState is UiDataReady) ...[
        IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () {
            setState(() {
              _searchMode = false;
            });
          },
        ),
      ],
      if (!_searchMode && uiState is UiDataReady) ...[
        IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            setState(() {
              _searchMode = true;
            });
          },
        ),
      ],
      () {
        final enableRefreshButton = _enableRefreshButton(uiState);

        return IconButton(
          icon: Icon(Icons.refresh, color: enableRefreshButton ? Colors.black : Colors.black45),
          onPressed: () {
            if (enableRefreshButton) {
              _zappingProvider.getMatches();
            }
          },
        );
      }(),
    ];
  }

  bool _enableRefreshButton(UiState uiState) {
    return !_searchMode && uiState is! UiLoading;
  }
}
