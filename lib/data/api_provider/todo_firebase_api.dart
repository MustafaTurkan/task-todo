import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/infrastructure/logger/logger.dart';

class TodoFirebaseApi {
  TodoFirebaseApi(this.logger) : _firestore = Firestore.instance;

  static const String collectionName = 'Todo';
  final Firestore _firestore;
  final Logger logger;

  Future<void> saveTodo(TodoModel todoModel) async {
    try {
      var id = _firestore.collection(collectionName).document().documentID;
      todoModel.id = id;
      var todoMap = todoModel.toMap();
      await _firestore.collection(collectionName).document(id).setData(todoMap);
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<TodoModel> readTodo(String id) async {
    try {
      DocumentSnapshot snap = await _firestore.collection(collectionName).document(id).get();
      return TodoModel.fromMap(snap.data);
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _firestore.collection(collectionName).document(id).delete();
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }
  
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _firestore.collection(collectionName).document(todo.id).updateData(todo.toMap());
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<List<TodoModel>> getTodos() async {
    try {
      List<TodoModel> todoModels = [];
      QuerySnapshot querySnapshot;
      querySnapshot = await _firestore.collection(collectionName).getDocuments();
      if (querySnapshot.documents.isEmpty){
        return null;
      }   
      for (DocumentSnapshot item in querySnapshot.documents) {
        TodoModel todoModel = TodoModel.fromMap(item.data);
        todoModels.add(todoModel);
      }
      return todoModels;
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }
}
