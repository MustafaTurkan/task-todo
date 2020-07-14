import 'package:flutter/material.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/ui/views/todo/add_view.dart';
import 'package:todo/ui/views/login/register_view.dart';
import 'package:todo/ui/views/todo/update_view.dart';

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();

  void pushRegister(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (context) => RegisterView()));
  }
  
  Future<TodoModel> pushAddTodo(BuildContext context) async{
  return await Navigator.of(context,).push<dynamic>(MaterialPageRoute<dynamic>(fullscreenDialog: true,builder: (context) => AddView()));
  }

  Future<TodoModel> pushUptadeTodo(BuildContext context,TodoModel todoModel) async{
  return await Navigator.of(context,).push<dynamic>(MaterialPageRoute<dynamic>(fullscreenDialog: true,builder: (context) => UpdateView(todoModel:todoModel,)));
  }

  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }
}
