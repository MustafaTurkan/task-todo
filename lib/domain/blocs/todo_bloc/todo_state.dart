part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoFail extends TodoState {
  TodoFail({@required this.reason});
  final String reason;
  @override
  String toString() => 'TodoFail { reason: $reason }';
}

class TodoLoadSuccess extends TodoState {
  TodoLoadSuccess({this.todoModel});
  final List<TodoModel> todoModel;
}

class TodoLoadByIdSuccess extends TodoState {
  TodoLoadByIdSuccess({this.todoModel});
  final TodoModel todoModel;
}
