import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:zapping_flutter/di/di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();

@module
abstract class Module {
  @lazySingleton
  HttpWithMiddleware getHttp() => HttpWithMiddleware.build(
      middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);
}
