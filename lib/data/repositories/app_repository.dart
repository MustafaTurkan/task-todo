import 'package:todo/data/api_provider/todo_firebase_api.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/domain/repositories/iapp_repository.dart';

class AppRepository extends IAppRepository {
  AppRepository({this.api});
  final TodoFirebaseApi api;

  @override
  Future<TodoModel> getById(String id) async {
    try {
      return api.readTodo(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TodoModel>> getList() async {
    try {
      return api.getTodos();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> add(TodoModel todoModel) async {
    try {
      await api.saveTodo(todoModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await api.deleteTodo(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> update(TodoModel todo) async {
    try {
      await api.updateTodo(todo);
    } catch (e) {
      rethrow;
    }
  }
}
