import 'dart:async';
import 'dart:isolate';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/infrastructure/app_info.dart';




typedef Future<void> AppMain();

class AppErrorHandler {
  AppErrorHandler();

  static void Function(AppErrorReport error) onShow;
  static void Function(AppErrorReport error) onReport;

  static Future<void> track(AppMain appMain) async {
    FlutterError.onError = (details) async {
      await _handle(details.exception, details.stack);
    };

    Isolate.current.addErrorListener(RawReceivePort((List<dynamic> isolateError) async {
 
      await _handle(
          isolateError.first.toString(), isolateError.last.toString());
    }).sendPort);

    await runZoned<Future<void>>(appMain, onError: (dynamic error, dynamic stackTrace) async {
      await _handle(error, stackTrace);
    });
  }

  static Future<void> _handle(dynamic error, dynamic stackTrace) async {
    if (!kReleaseMode) {
      debugPrint('AppErrorHandler error: $error');
      debugPrint('AppErrorHandler stackTrace: $stackTrace');
    }

    var appErrorReport = AppErrorReport(
      error,
      stackTrace,
      clock.now(),
      deviceInfo: await AppInfo.getDeviceInfo(),
      applicationInfo: await AppInfo.getAppInfo(),
    );

    try {
      if (onReport != null) {
        onReport(appErrorReport);
      }
    } catch (e) {
      if (!kReleaseMode) {
        rethrow;
      } else {
        //can we do anything ???
      }
    }

    try {
      if (onShow != null) {
        onShow(appErrorReport);
      }
    } catch (e) {
      if (!kReleaseMode) {
        rethrow;
      } else {
        //can we do anything ???
      }
    }
  }

  static Future<AppErrorReport> _createAppError(
      dynamic exceptionORerror) async {
    StackTrace stackTrace;

    if (exceptionORerror is Error) {
      stackTrace = exceptionORerror.stackTrace;
    }

    return AppErrorReport(
      exceptionORerror,
      stackTrace,
      clock.now(),
      deviceInfo: await AppInfo.getDeviceInfo(),
      applicationInfo: await AppInfo.getAppInfo(),
    );
  }

  static Future<void> show(dynamic exceptionORerror) async {
    if (onShow == null) {
      throw Exception('onShow method is null !');
    }

    onShow(await _createAppError(exceptionORerror));
  }

  static Future<void> report(dynamic exceptionORerror) async {
    if (onReport == null) {
      throw Exception('onShow method is null !');
    }
    onReport(await _createAppError(exceptionORerror));
  }
}

class AppErrorReport {
  AppErrorReport(
    this.error,
    this.stackTrace,
    this.dateTime, {
    this.deviceInfo,
    this.applicationInfo,
  });

  final dynamic error;
  final dynamic stackTrace;
  final DateTime dateTime;
  final Map<String, dynamic> deviceInfo;
  final Map<String, dynamic> applicationInfo;
}
