import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo/data/api_provider/authentication_api.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/data/api_provider/todo_firebase_api.dart';
import 'package:todo/data/repositories/user_repository.dart';
import 'package:todo/domain/blocs/bloc_delegate.dart';
import 'package:todo/domain/repositories/i_todo_repository.dart';
import 'package:todo/domain/repositories/i_user_repository.dart';
import 'package:todo/infrastructure/app_context.dart';
import 'package:todo/infrastructure/error/app_error_handler.dart';
import 'package:todo/infrastructure/logger/log_debug_print.dart';
import 'package:todo/infrastructure/logger/logger.dart';
import 'package:todo/ui/app_navigator.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
 locator.registerLazySingleton(() => AppContext());
 locator.registerLazySingleton(() => AppNavigator());
 locator.registerLazySingleton(() => Logger());
 locator.registerLazySingleton(() => TodoFirebaseApi(Logger(),locator.get<AppContext>()));
 locator.registerLazySingleton(() => AuthenticationApi(Logger()));
 locator.registerLazySingleton<ITodoRepository>(() => TodoRepository(api:locator.get<TodoFirebaseApi>()));
 locator.registerLazySingleton<IUserRepository>(() => UserRepository(api:locator.get<AuthenticationApi>()));
 run();
}

void run() {
  Bloc.observer = AppBlocDelegate();
  AppErrorHandler.onReport = reportError;
  AppErrorHandler.onShow = showError;
  AppErrorHandler.track(() async {
    WidgetsFlutterBinding.ensureInitialized();
    buildLogListeners();
  });
}

void buildLogListeners() {
  Logger.onLog.listen(LogDebugPrint.write);
}

Future<void> showError(AppErrorReport appError) async {
  assert(AppNavigator.key.currentState != null, 'Navigator state null!');
  //Add Dialog
  //ErrorLocalizer.translate(appError)
  var sb = StringBuffer();
  sb.write('AppErrorReport');
  sb.write(appError.error?.toString() ?? 'error type empty!');
  if (kDebugMode) {
    sb.write(appError.stackTrace?.toString() ?? 'stacktrace empty!');
  }
  locator.get<Logger>().error(sb.toString());
}

Future<void> reportError(AppErrorReport appError) async {
  var sb = StringBuffer();
  sb.write('AppErrorReport');
  sb.write(appError.error?.toString() ?? 'error type empty!');
  if (kDebugMode) {
    sb.write(appError.stackTrace?.toString() ?? 'stacktrace empty!');
  }
  // add device info to log.
  // report  FireBase
  locator.get<Logger>().error(sb.toString());
}
