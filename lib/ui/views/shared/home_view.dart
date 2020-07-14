
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/domain/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/error/error_localizer.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/views/shared/error_view.dart';
import 'package:todo/ui/views/todo/add_view.dart';
import 'package:todo/ui/views/todo/todo_list_view.dart';
import 'package:todo/ui/widgets/animations/open_view_with_floatingaction_button.dart';
import 'package:todo/ui/widgets/navigation_bar/titled_botttom_navigation_bar.dart';
import 'package:todo/ui/widgets/navigation_bar/titled_navigation_bar_item.dart';
import 'package:todo/ui/widgets/waiting_view.dart';
import 'package:todo/ui/views/shared/empty_view.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  List<TitledNavigationBarItem> items;
  Localizer _localizer;
  TodoType _type;
  TodoBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.bloc<TodoBloc>();
    _localizer = Localizer.of(context);
    _type = TodoType.daily;
    items = [
      TitledNavigationBarItem(title: Text(_localizer.daily), icon: Icons.perm_contact_calendar),
      TitledNavigationBarItem(title: Text(_localizer.weekly), icon: Icons.perm_contact_calendar),
      TitledNavigationBarItem(title: Text(_localizer.monthly), icon: Icons.perm_contact_calendar),
      TitledNavigationBarItem(title: Text(_localizer.other), icon: Icons.perm_contact_calendar),
    ];
  }

  @override
  Widget build(BuildContext context) {
    initialLoadTodo(bloc);
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      if (state is TodoLoadSuccess) {
        return Scaffold(
          body: Container(child: todoListView(state.todoModel)),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: OpenViewWithFloatingActionButton(view: AddView(), onClosed: onAddTodo),
          /*FloatingActionButton(
            onPressed: () => onPressAdd(context, bloc),
            child: Icon(Icons.add),
          ),*/
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

  void onAddTodo(TodoModel todoModel) {
    if (todoModel != null) {
      bloc.add(OnAdd(todo: todoModel));
    }
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
