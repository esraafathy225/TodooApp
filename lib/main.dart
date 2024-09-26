import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_todoo_app/cubits/todo_cubit.dart';
import 'package:my_todoo_app/pages/home_page.dart';
import 'package:my_todoo_app/pages/settings_page.dart';
import 'package:my_todoo_app/themes/theme.dart';
import 'package:my_todoo_app/themes/themes_provider.dart';
import 'package:provider/provider.dart';
import 'data/models/todo_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  final myBox = await Hive.openBox<TodoModel>('todoBox');
  runApp(ChangeNotifierProvider(
    create: (context) => ThemesProvider(),
    child:  MyApp(todoBox: myBox,),
  ));
}

class MyApp extends StatelessWidget {
  final Box<TodoModel> todoBox;

  MyApp({required this.todoBox});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemesProvider>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoCubit(todoBox),
        child:  HomePage(),
      ),
      routes: {'/settingsPage': (context) => const SettingsPage()},
    );
  }
}
