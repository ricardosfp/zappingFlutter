import 'package:flutter/material.dart';
import 'package:zapping_flutter/ui/view_model/zapping_provider.dart';

class ZappingWidget extends StatefulWidget {
  const ZappingWidget({super.key});

  @override
  State<ZappingWidget> createState() => _ZappingWidgetState();
}

class _ZappingWidgetState extends State<ZappingWidget> {
  // todo inject this
  late final zappingProvider = ZappingProvider();

  @override
  void initState() {
    super.initState();
    zappingProvider.getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Zapping"),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Zapping will show here",
                style: TextStyle(fontSize: 24),
              ),
              Spacer(),
            ],
          ),
        ));
  }
}
