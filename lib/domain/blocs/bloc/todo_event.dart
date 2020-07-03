part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}


class OnLoad extends TodoEvent{}

class OnAdd extends TodoEvent
{
  OnAdd({this.todo});
  final TodoModel todo;
}

class OnDelete extends TodoEvent
{
  OnDelete({this.id});
  final String id;
}

class OnLoadById extends TodoEvent
{
  OnLoadById({this.id});
  final String id;
}

class OnUpdate extends TodoEvent
{
  OnUpdate({this.todo});
  final TodoModel todo;
}