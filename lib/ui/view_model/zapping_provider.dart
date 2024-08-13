import 'package:flutter/widgets.dart';
import 'package:zapping_flutter/data/repository/implementation/zapping_repository_impl.dart';
import 'package:zapping_flutter/main.dart';

class ZappingProvider extends ChangeNotifier {
  // todo this should be injected
  late final _zappingRepository = ZappingRepositoryImpl();

  void getMatches() async {
    final articleList = await _zappingRepository.getMatches(zappingUrl);

    // todo parse the matches
  }
}
