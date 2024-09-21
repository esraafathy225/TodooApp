import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_todoo_app/components/dialog_box.dart';
import 'package:my_todoo_app/components/todo_tile.dart';
import 'package:my_todoo_app/data/models/todo_model.dart';
import 'package:my_todoo_app/data/todo_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var todoDatabase = TodoDatabase();

  List<TodoModel> todoList= [];

  @override
  void initState() {
    todoList= todoDatabase.getTodos();
  }

  final _controller = TextEditingController();
  
  void onCheckedBoxChanged(bool? value, int index){
    setState(() {
      todoList[index].isCompleted = ! todoList[index].isCompleted;
      todoDatabase.updateTodo(index, todoList[index]);
    });
  }

  void onCancelDialog(){
    _controller.clear();
    Navigator.pop(context);
  }

  void onSaveTask(){
    setState(() {
      var newTask = TodoModel(taskName: _controller.text, isCompleted: false);
      todoList.add(newTask);
      todoDatabase.addTodo(newTask);
    });

    _controller.clear();
    Navigator.pop(context);
  }

  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox(
        controller: _controller,
        onCancel: onCancelDialog,
        onSave: onSaveTask,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text(
            'Todo App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade900,
          onPressed: createNewTask,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        body: ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(todoList[index].taskName),
                direction: DismissDirection.endToStart,
                onDismissed: (direction){
                  setState(() {
                    todoList.removeAt(index);
                    todoDatabase.deleteTodo(index);
                  });
                },
                child: TodoTile(
                    taskName: todoList[index].taskName,
                    isCompleted: todoList[index].isCompleted,
                    onChanged: (value) => onCheckedBoxChanged(value, index)),
              );
            }));
  }
}
