import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_todoo_app/components/dialog_box.dart';
import 'package:my_todoo_app/components/todo_tile.dart';
import 'package:my_todoo_app/cubits/todo_cubit.dart';
import 'package:my_todoo_app/data/models/todo_model.dart';
import 'package:my_todoo_app/data/todo_database.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key});

  final _controller = TextEditingController();

  void onCancelDialog(BuildContext context) {
    _controller.clear();
    Navigator.pop(context);
  }

  void onSaveTask(BuildContext context) {
    context.read<TodoCubit>().addTodo(_controller.text);
    _controller.clear();
    Navigator.pop(context);
  }

  void createNewTask(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onCancel: () => onCancelDialog(context),
            onSave: () => onSaveTask(context),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Todo App',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settingsPage');
                },
                icon: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.settings),
                  ),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewTask(context),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        body: BlocBuilder<TodoCubit,List<TodoModel>>(builder: (context,todoList){
          return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(todoList[index].taskName),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<TodoCubit>().deleteTodo(index);
                  },
                  child: TodoTile(
                      taskName: todoList[index].taskName,
                      isCompleted: todoList[index].isCompleted,
                      onChanged: (value) => context.read<TodoCubit>().updateTodo(index),
                ));
              });
        })
    );
  }
}
