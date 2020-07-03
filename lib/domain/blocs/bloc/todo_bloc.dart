import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/app_repository.dart';
import 'package:todo/infrastructure/app_string.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/error/app_exception.dart';
import 'package:todo/infrastructure/logger/logger.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({this.repository, this.logger});
  final AppRepository repository;
  final Logger logger;

  @override
  TodoState get initialState => TodoInitial();

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is OnLoad) {
      yield* _mapTodoLoad();
    } else if (event is OnLoadById) {
      yield* _mapTodoLoadById(event);
    } else if (event is OnAdd) {
      yield* _mapTodoAdd(event);
    }
    else if(event is OnDelete)
    {
       yield* _mapTodoDelete(event);  
    }
        else if(event is OnUpdate)
    {
       yield* _mapTodoUpdate(event);  
    }
  }

  

  Stream<TodoState> _mapTodoLoad() async* {
    try {
      yield TodoLoading();
      var todoList = await repository.getList();
      yield TodoLoadSuccess(todoModel: todoList);
    } on AppException catch (e) {
      //firebase exeption
      yield TodoFail(reason: e.message);
      logger.error(e);
    } catch (e) {
      yield TodoFail(reason: AppString.unExpectedErrorOccurred);
      logger.error(e);
    }
  }

  Stream<TodoState> _mapTodoLoadById(OnLoadById event) async* {
    try {
      yield TodoLoading();
      var todo = await repository.getById(event.id);
      if (todo == null) {
        yield TodoFail(reason: AppString.unExpectedErrorOccurred);
        logger.error(AppString.unExpectedErrorOccurred);
      } else {
        yield TodoLoadByIdSuccess(todoModel: todo);
      }
    } on AppException catch (e) {
      //firebase exeption
      yield TodoFail(reason: e.message);
      logger.error(e);
    } catch (e) {
      yield TodoFail(reason: AppString.unExpectedErrorOccurred);
      logger.error(e);
    }
  }

  Stream<TodoState> _mapTodoAdd(OnAdd event) async* {
    try {
      yield TodoLoading();
      event.todo.createdDate=DateTime.now();
      setFinishedDate(event.todo);
            await repository.add(event.todo);
            var todoList = await repository.getList();
            if (todoList == null) {
              yield TodoFail(reason: AppString.unExpectedErrorOccurred);
              logger.error(AppString.unExpectedErrorOccurred);
            } else {
              yield TodoLoadSuccess(todoModel: todoList);
            }
          } on AppException catch (e) {
            //firebase exeption
            yield TodoFail(reason: e.message);
            logger.error(e);
          } catch (e) {
            yield TodoFail(reason: AppString.unExpectedErrorOccurred);
            logger.error(e);
          }
        }
      
          Stream<TodoState> _mapTodoDelete(OnDelete event) async* {
          try {
            yield TodoLoading();
            await repository.delete(event.id);
            var todoList = await repository.getList();
              yield TodoLoadSuccess(todoModel: todoList);   
          } on AppException catch (e) {
            //firebase exeption
            yield TodoFail(reason: e.message);
            logger.error(e);
          } catch (e) {
            yield TodoFail(reason: AppString.unExpectedErrorOccurred);
            logger.error(e);
          }
        }
      
            Stream<TodoState> _mapTodoUpdate(OnUpdate event) async* {
          try {
            yield TodoLoading();
            await repository.update(event.todo);
            var todoList = await repository.getList();
              yield TodoLoadSuccess(todoModel: todoList);   
          } on AppException catch (e) {
            //firebase exeption
            yield TodoFail(reason: e.message);
            logger.error(e);
          } catch (e) {
            yield TodoFail(reason: AppString.unExpectedErrorOccurred);
            logger.error(e);
          }
        }
      
        void setFinishedDate(TodoModel todo) {
            if (todo.period==TodoType.daily.index) {
               todo.finishedDate=todo.createdDate.add(Duration(days:1));
            }else if(todo.period==TodoType.weekly.index)
            {
                todo.finishedDate=todo.createdDate.add(Duration(days:7));
            }
            else{
                todo.finishedDate=todo.createdDate.add(Duration(days:30));
            }

        }


}
