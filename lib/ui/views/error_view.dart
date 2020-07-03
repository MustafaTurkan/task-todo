import 'package:flutter/material.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/ui/theme/theme.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key key, this.errorText}) : super(key: key);
  final String errorText;
  @override
  Widget build(BuildContext context) {

    return Container(
      child:  Scaffold(
           appBar:WhiteThemeUtils.appBarWithLinearGradient(context, Localizer.instance.error,isShowLeading: false),
            body: Center(
          child: Text(errorText),
        )),
    );
  }
}