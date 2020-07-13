import 'package:flutter/material.dart';
import 'package:todo/ui/views/register_view.dart';

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();

  void pushRegister(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (context) => RegisterView()));
  }

  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }
}
