import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_task/hive/todo_adapter.dart';
import 'package:todo_task/provider/todos.dart';

import 'provider/auth.dart';
import 'screens/add_todo.dart';
import 'screens/auth_screen.dart';
import 'screens/details_todo.dart';
import 'screens/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox('todos');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Todos>(
          create: (ctx) => Todos(),
          update: (ctx, auth, previousTodos) =>
              previousTodos!..setParams(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, authData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'To Do Task',
          home: const AuthScreen(),
          routes: {
            AuthScreen.routeName: (context) => const AuthScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            AddTodoScreen.routeName: (context) => const AddTodoScreen(),
            DetailsTodoScreen.routeName: (context) => const DetailsTodoScreen(),
          },
        );
      }),
    );
  }
}
