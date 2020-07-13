import 'package:todo/data/models/todo_model.dart';

abstract class ITodoRepository {
  Future<TodoModel> getById(String id);
  Future<List<TodoModel>> getList();
  Future<void> add(TodoModel todoModel);
  Future<void> delete(String id);
  Future<void> update(TodoModel todo);
}
