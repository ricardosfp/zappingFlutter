import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapping_flutter/di/di.dart';
import 'package:zapping_flutter/ui/view_model/zapping_provider.dart';
import 'package:zapping_flutter/ui/widget/zapping_item.dart';

class ZappingScreen extends StatefulWidget {
  const ZappingScreen({super.key});

  @override
  State<ZappingScreen> createState() => _ZappingScreenState();
}

class _ZappingScreenState extends State<ZappingScreen> {
  late final _zappingProvider = getIt<ZappingProvider>();

  @override
  void initState() {
    super.initState();
    _zappingProvider.getMatches();
  }

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
                      child: ZappingItem(match: match),
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
