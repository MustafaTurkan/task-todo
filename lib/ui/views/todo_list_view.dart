import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/domain/blocs/bloc/todo_bloc.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/theme/theme.dart';
import 'package:todo/ui/widgets/alert_dialog/completed_action_alert_dialog.dart';
import 'package:todo/ui/widgets/alert_dialog/update_alert_dialog.dart';
import 'package:todo/ui/widgets/alert_dialog/wait_action_alert_dialog.dart';

class TodoListView extends StatefulWidget {
  TodoListView({Key key, this.todoList}) : super(key: key);
  final List<TodoModel> todoList;
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  _TodoListViewState() : _navigator = locator.get<AppNavigator>();

  final AppNavigator _navigator;
  AppTheme _appTheme;
  Localizer _localizer;

  @override
  void didChangeDependencies() {
    _appTheme = Provider.of<AppTheme>(context);
    _localizer = Localizer.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TodoStatus.values.length,
      child: Scaffold(
        appBar: AppBar(
            leading: null,
            centerTitle: true,
            title: Text(
              _localizer.appName,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: WhiteThemeUtils.linearGradient(),
              ),
            ),
            bottom: TabBar(
              indicatorColor: _appTheme.colors.canvas,
              tabs: <Widget>[
                Tab(
                  text: _localizer.waiting,
                ),
                Tab(
                  text: _localizer.done,
                ),
              ],
            )),
        body: Center(
          child: TabBarView(
            children: [
              todoListBuilder(TodoStatus.waiting),
              todoListBuilder(TodoStatus.done),
            ],
          ),
        ),
      ),
    );
  }

  Widget todoListBuilder(TodoStatus status) {
    var todoListFromStatus = widget.todoList.where((item) => item.status == status.index).toList();
    return RefreshIndicator(
      onRefresh: () async {
        onLoad(context);
      },
      child: ListView.builder(
          itemCount: todoListFromStatus.length,
          itemBuilder: (context, i) {
            var todo = todoListFromStatus[i];
            return Card(
              margin: EdgeInsets.all(2),
              elevation: 1,
              child: ListTile(
                leading: remainingTime(todo),
                title: Text(
                  todo.title,
                  style: _appTheme.data.textTheme.subtitle1
                      .copyWith(color: _appTheme.colors.fontDark, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  todo.text,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.menu),
                onLongPress: () async {
                  await _buildDialog(status, context, todo);
                },
              ),
            );
          }),
    );
  }

  Widget remainingTime(TodoModel todo) {
    if (todo.status == TodoStatus.waiting.index) {
      return CircleAvatar(
        backgroundColor: _colorRemainingTime(todo.remainingTime.time),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              todo.remainingTime.time == 0 ? _localizer.time : todo.remainingTime.time.toString(),
              style: _appTheme.data.textTheme.caption.copyWith(
                color: _appTheme.colors.fontLight,
              ),
            ),
            Text(
              _periodRemainingTime(todo.remainingTime),
              style: _appTheme.data.textTheme.caption.copyWith(
                color: _appTheme.colors.fontLight,
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }

  Color _colorRemainingTime(int time) {
    if (time == 0) {
      return _appTheme.colors.error;
    } else {
      return _appTheme.colors.primary;
    }
  }

  String _periodRemainingTime(RemainingTime remainingTime) {
    if (remainingTime.time == 0) {
      return _localizer.up;
    }

    if (remainingTime.timeType == TimeType.day) {
      return _localizer.day;
    }

    return _localizer.hour;
  }

  Future<void> _buildDialog(TodoStatus status, BuildContext context, TodoModel todo) async {
    if (status == TodoStatus.done) {
      await _showCompletedActionDialog(context, todo);
    } else {
      await _showWaitingActionDialog(context, todo);
    }
  }

  Future<void> _showCompletedActionDialog(BuildContext context, TodoModel todo) async {
    await showDialog(
        context: context,
        builder: (context) {
          var bloc = BlocProvider.of<TodoBloc>(context);
          return CompletedActionAlertDialog(
            title: todo.title,
            onDelete: () {
              onDelete(bloc, todo.id);
            },
            onUpdate: () async {
              await _showUpdateDialog(context, todo);
              _navigator.pop(context);
            },
            onWait: () {
              todo.status = TodoStatus.waiting.index;
              onChange(bloc, todo);
            },
          );
        });
  }

  Future<void> _showWaitingActionDialog(BuildContext context, TodoModel todo) async {
    await showDialog(
        context: context,
        builder: (context) {
          var bloc = BlocProvider.of<TodoBloc>(context);
          return WaitActionAlertDialog(
            title: todo.title,
            onDelete: () {
              onDelete(bloc, todo.id);
            },
            onUpdate: () async {
              await _showUpdateDialog(context, todo);
              _navigator.pop(context);
            },
            onDone: () {
              todo.status = TodoStatus.done.index;
              onChange(bloc, todo);
            },
          );
        });
  }

  Future<void> _showUpdateDialog(BuildContext context, TodoModel todo) async {
    await showDialog(
        context: context,
        builder: (context) {
          var bloc = Provider.of<TodoBloc>(context);
          return UpdateAlertDialog(
            todoModel: todo,
            onCancel: () {
              _navigator.pop(context);
            },
            onUpdate: (todo) {
              onChange(bloc, todo);
            },
          );
        });
  }

  void onChange(TodoBloc bloc, TodoModel todo) {
    bloc.add(OnUpdate(todo: todo));
    _navigator.pop(context);
  }

  void onDelete(TodoBloc bloc, String id) {
    bloc.add(OnDelete(id: id));
    _navigator.pop(context);
  }

  void onLoad(BuildContext context) {
    var bloc = BlocProvider.of<TodoBloc>(context);
    bloc.add(OnLoad());
  }
}
