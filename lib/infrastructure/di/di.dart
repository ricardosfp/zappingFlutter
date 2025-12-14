import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/data/services/database/drift_database.dart';
import 'package:zapping_flutter/infrastructure/di/di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();

@module
abstract class Module {
  @lazySingleton
  HttpWithMiddleware getHttp() =>
      HttpWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);

  @Named(DiName.zappingUrl)
  @lazySingleton
  String getZappingUrl() {
    return const String.fromEnvironment("zappingUrl");
  }

  @lazySingleton
  AppDatabase getDatabase() => AppDatabase();
}

abstract final class DiName {
  static const zappingUrl = "zappingUrl";
}
