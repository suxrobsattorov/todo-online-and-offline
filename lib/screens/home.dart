import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_task/provider/todos.dart';

import '../constants/Colors.dart';
import '../constants/user_id.dart';
import '../hive/todo_hive.dart';
import '../models/todo.dart';
import '../widgets/add_event_button.dart';
import '../widgets/main_image.dart';
import '../widgets/my_appbar.dart';
import '../widgets/schedule.dart';
import 'details_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future _todosFuture;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();

  var todos = Hive.box('todos');

  var isOnline = false;
  List<TodoHive> todoLocalList = [];

  Future _getProductsFuture() {
    return Provider.of<Todos>(context, listen: false).getTodosFromFirebase();
  }

  void autoLoading() {
    if (isOnline && todoLocalList.isNotEmpty) {
      for (int i = 0; i < todoLocalList.length; i++) {
        if (todoLocalList[i].id == UserId.userId) {
          Provider.of<Todos>(context, listen: false).addTodo(
            Todo(
              id: '',
              name: todoLocalList[i].name,
              description: todoLocalList[i].description,
              date: todoLocalList[i].date,
              isDone: false,
            ),
          );
          todoLocalList.removeAt(i);
          todos.deleteAt(i);
        }
      }
      todoLocalList.clear();
    }
    _todosFuture = _getProductsFuture();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _todosFuture = _getProductsFuture();
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      rethrow;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = result;
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.mobile) {
      setState(() {
        isOnline = true;
        autoLoading();
      });
    } else {
      setState(() {
        isOnline = false;
      });
    }
    todoLocalList = todos.values.toList().cast();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const MyAppBar(),
              const SizedBox(height: 20),
              const MainImage(),
              const SizedBox(height: 20),
              const AddTodoButton(),
              const SizedBox(height: 20),
              isOnline
                  ? FutureBuilder(
                      future: _todosFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.error == null) {
                            return Consumer<Todos>(
                              builder: (c, todos, child) {
                                final todoList = todos.list;
                                return todoList.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: todoList.length,
                                        itemBuilder: (context, index) {
                                          Color color1 = AppColors.appBlue;
                                          Color color2 = AppColors.appBlue2;
                                          Todo todo = todoList[
                                              todoList.length - 1 - index];
                                          if (todo.date!
                                                  .isBefore(DateTime.now()) &&
                                              todo.isDone == false) {
                                            color1 = AppColors.appRed;
                                            color2 = AppColors.appRed2;
                                          } else if (todo.isDone) {
                                            color1 = AppColors.appGreen;
                                            color2 = AppColors.appGreen2;
                                          }
                                          return InkWell(
                                            onTap: () => Navigator.of(context)
                                                .pushReplacementNamed(
                                              DetailsTodoScreen.routeName,
                                              arguments: todo.id,
                                            ),
                                            child: Schedule(
                                              color1: color1,
                                              color2: color2,
                                              todo: todo,
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text('Rejalar mavjud emas'),
                                      );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Xatolik sodir bo\'ldi.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                        }
                      },
                    )
                  : const Center(
                      child: Text(
                        'Internetga ulanmagansiz',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
