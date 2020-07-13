import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo/domain/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo/domain/repositories/i_user_repository.dart';
import 'package:todo/infrastructure/app_context.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/infrastructure/logger/logger.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/theme/themes/white/white.dart';
import 'package:todo/ui/views/landing_view.dart';
import 'infrastructure/app_string.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp()
      : _logger = locator.get<Logger>(),
        _userRepository = locator.get<IUserRepository>(),
        _context = locator.get<AppContext>();

  final Logger _logger;
  final IUserRepository _userRepository;
  final AppContext _context;

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
          home: LandingView(),
        ));
  }

  Widget _builder(BuildContext context, Widget child) {
    var theme = Provider.of<AppTheme>(context);
    if (!theme.initialized) {
      theme.setTheme(buildWhiteTheme(context));
    }
    return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: Theme(data: theme.data, child: child));
  }

  List<SingleChildWidget> _providers() {
    Provider.debugCheckInvalidValueType = null;
    return [
      ChangeNotifierProvider<AppTheme>(create: (context) => AppTheme()),
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(logger: _logger, userRepository: _userRepository, context: _context)
          ..add(AuthenticationStarted()),
      ),
    ];
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationsDelegates() {
    return [AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate];
  }

  Iterable<Locale> _supportedLocales() {
    return [const Locale('en'), const Locale('tr')];
  }
}
