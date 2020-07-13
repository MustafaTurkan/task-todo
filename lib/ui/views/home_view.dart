import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/domain/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/error/error_localizer.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/views/error_view.dart';
import 'package:todo/ui/views/todo_list_view.dart';
import 'package:todo/ui/widgets/alert_dialog/add_alert_dialog.dart';
import 'package:todo/ui/widgets/navigation_bar/titled_botttom_navigation_bar.dart';
import 'package:todo/ui/widgets/navigation_bar/titled_navigation_bar_item.dart';
import 'package:todo/ui/widgets/waiting_view.dart';
import 'package:todo/ui/views/empty_view.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState() : _navigator = locator.get<AppNavigator>();
 
  final AppNavigator _navigator;

  List<TitledNavigationBarItem> items;
  Localizer _localizer;
  TodoType _type;

  @override
  void didChangeDependencies() {
    _localizer = Localizer.of(context);
    _type = TodoType.daily;
    items = [
      TitledNavigationBarItem(title: Text(_localizer.daily), icon: Icons.perm_contact_calendar),
      TitledNavigationBarItem(title: Text(_localizer.weekly), icon: Icons.perm_contact_calendar),
      TitledNavigationBarItem(title: Text(_localizer.monthly), icon: Icons.perm_contact_calendar),
      TitledNavigationBarItem(title: Text(_localizer.other), icon: Icons.perm_contact_calendar),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.bloc<TodoBloc>();
    initialLoadTodo(bloc);
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      if (state is TodoLoadSuccess) {
        return Scaffold(
          body: Container(child: todoListView(state.todoModel)),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () => onPressAdd(context, bloc),
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: TitledBottomNavigationBar(
            currentIndex: _type.index,
            onTap: setTodoType,
            reverse: false,
            curve: Curves.easeInBack,
            items: items,
          ),
        );
      } else if (state is TodoFail) {
        return ErrorView(errorText: ErrorLocalizer.translate(state.reason));
      } else {
        return Scaffold(body: WaitingView());
      }
    });
  }

  void onPressAdd(BuildContext context, TodoBloc bloc) {
    _showAddDialog(context, bloc);
  }

  Future<void> _showAddDialog(BuildContext context, TodoBloc bloc) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAlertDialog(
          onAdd: (todo) {
            bloc.add(OnAdd(todo: todo));
            _navigator.pop(context);
          },
          onCancel: () {
            _navigator.pop(context);
          },
        );
      },
    );
  }

  Widget todoListView(List<TodoModel> todos) {
    if (todos == null) {
      return EmptyView();
    }
    var todosFromPeriod = todos.where((item) => item.period == _type.index).toList();
    return TodoListView(
      todoList: todosFromPeriod,
    );
  }

  void setTodoType(int index) {
    setState(() {
      if (TodoType.daily.index == index) {
        _type = TodoType.daily;
      } else if (TodoType.weekly.index == index) {
        _type = TodoType.weekly;
      } else if (TodoType.monthly.index == index) {
        _type = TodoType.monthly;
      } else {
        _type = TodoType.other;
      }
    });
  }

  void initialLoadTodo(TodoBloc bloc) {
    if (bloc.state is TodoInitial) {
      bloc.add(OnLoad());
    }
  }
}
