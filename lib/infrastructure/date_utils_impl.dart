import 'package:injectable/injectable.dart';
import 'package:zapping_flutter/infrastructure/date_utils.dart';

@LazySingleton(as: DateUtils)
class DateUtilsImpl implements DateUtils {
  @override
  DateTime dateAtMidnight(DateTime date) {
    return date.copyWith(hour: 0, minute: 0, second: 0);
  }
}
