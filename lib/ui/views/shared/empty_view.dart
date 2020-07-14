import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/domain/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/ui/theme/theme.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    var localizer = Localizer.of(context);
    return Scaffold(
        appBar: AppBar(
          leading: null,
          centerTitle: true,
          title: Text(
            localizer.appName,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: WhiteThemeUtils.linearGradient(),
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                onSingOut(context);
              },
              icon: Icon(FontAwesomeIcons.signOutAlt, color: appTheme.colors.fontLight),
            )
          ],
        ),
        body: Center(
          child: Text(localizer.emptyMessage),
        ));
  }

  void onSingOut(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(
      AuthenticationLoggedOut(),
    );
  }
}
