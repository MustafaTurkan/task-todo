




import 'package:todo/infrastructure/app_string.dart';
import 'package:todo/infrastructure/error/app_error_handler.dart';
import 'package:todo/infrastructure/error/app_exception.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';

class ErrorLocalizer {
  ErrorLocalizer._();

  static String translate(Object ex) {
    //Test içinde null olabiliyor
    if (Localizer.instance == null) {
      return AppString.unExpectedErrorOccurred;
    }

    if (ex is AppErrorReport) {
      if (ex.error is AppException) {
        return Localizer.instance.translate(ex.error.message as String);
      }
    }

    if (ex is AppException) {
      return Localizer.instance.translate(ex.message);
    }

    return Localizer.instance.translate(AppString.unExpectedErrorOccurred);
  }
}
