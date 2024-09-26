import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:my_todoo_app/data/models/todo_model.dart';

class TodoCubit extends Cubit<List<TodoModel>>{

  final Box<TodoModel> _todoBox;

  TodoCubit(this._todoBox) : super([]){
    loadTodos();
  }

  void loadTodos(){
    if(_todoBox.isNotEmpty){
      emit(_todoBox.values.toList());
    }
  }

  void addTodo(String title){
    final newTask= TodoModel(taskName: title, isCompleted: false);
    _todoBox.add(newTask);
    emit([...state,newTask]);
  }

  void updateTodo(int index){
    state[index].isCompleted = ! state[index].isCompleted;
    _todoBox.putAt(index, state[index]);
    emit([...state]);
  }

  void deleteTodo(int index){
    _todoBox.deleteAt(index);
    emit([...state]..removeAt(index));
  }
}