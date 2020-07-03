import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo/domain/blocs/bloc/todo_bloc.dart';
import 'package:todo/domain/repositories/iapp_repository.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/infrastructure/logger/logger.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/theme/themes/white/white.dart';
import 'package:todo/ui/views/home_view.dart';

import 'infrastructure/app_string.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp()
      :_logger = locator.get<Logger>(),
      _repository=locator.get<IAppRepository>()
      ;
        
  final Logger _logger;
  final IAppRepository _repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [..._providers()],
        child: MaterialApp(
          title: AppString.appName,
          localizationsDelegates: _localizationsDelegates(),
          supportedLocales: _supportedLocales(),
          builder: _builder,
          navigatorKey: AppNavigator.key,
          navigatorObservers: [AppNavigator.routeObserver],
          home:HomeView(),
        ));
  }

  Widget _builder(BuildContext context, Widget child) {
    var theme = Provider.of<AppTheme>(context);
    if (!theme.initialized) {
      theme.setTheme(buildWhiteTheme(context));
    }
    return Theme(data: theme.data, child: child);
  }

  List<SingleChildWidget> _providers() {
    Provider.debugCheckInvalidValueType = null;
    return [
      ChangeNotifierProvider<AppTheme>(create: (context) => AppTheme()),
      BlocProvider<TodoBloc>(create: (context) =>TodoBloc(logger:_logger,repository:_repository) ,)
    ];
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationsDelegates() {
    return [AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate];
  }

  Iterable<Locale> _supportedLocales() {
    return [const Locale('en'), const Locale('tr')];
  }
}
