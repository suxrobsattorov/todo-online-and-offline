import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_task/constants/user_id.dart';
import 'package:todo_task/hive/todo_hive.dart';
import 'package:todo_task/provider/todos.dart';
import 'package:todo_task/screens/details_todo.dart';
import '../../models/todo.dart';
import '../constants/Colors.dart';
import '../constants/icons.dart';
import 'home.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  static const routeName = '/add-event';

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _form = GlobalKey<FormState>();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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

  var todos = Hive.box('todos');

  var isOnline = false;

  var _todo = Todo(
    id: '',
    name: '',
    description: '',
    date: null,
    isDone: false,
  );
  var _init = true;
  var _isLoading = false;

  void _planAddDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2026),
    ).then(
      (value) => {
        if (value != null)
          {
            setState(() {
              _todo = Todo(
                id: _todo.id,
                name: _todo.name,
                description: _todo.description,
                date: value,
                isDone: _todo.isDone,
              );
            })
          }
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final todoId = ModalRoute.of(context)!.settings.arguments;
      if (todoId != null) {
        final _editingTodo =
            Provider.of<Todos>(context).findById(todoId as String);
        _todo = _editingTodo;
      }
    }
    _init = false;
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_todo.id.isEmpty) {
        try {
          if (isOnline) {
            await Provider.of<Todos>(context, listen: false).addTodo(_todo);
          } else {
            todos.add(
              TodoHive(
                id: UserId.userId,
                name: _todo.name,
                description: _todo.description,
                date: _todo.date,
                isDone: _todo.isDone,
              ),
            );
          }
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Xatolik!'),
                  content:
                      const Text('Reja qo\'shishda xatolik sodir bo\'ldi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okay'),
                    ),
                  ],
                );
              });
        }
      } else {
        try {
          await Provider.of<Todos>(context, listen: false).updateTodo(_todo);
        } catch (e) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Xatolik!'),
                  content: const Text(
                      'Rejani o\'zgartirishda xatolik sodir bo\'ldi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okay'),
                    ),
                  ],
                );
              });
        }
      }

      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.mobile) {
      setState(() {
        isOnline = true;
      });
    } else {
      setState(() {
        isOnline = false;
      });
    }
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        _todo.id == ''
                            ? Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName)
                            : Navigator.of(context).pushReplacementNamed(
                                DetailsTodoScreen.routeName,
                                arguments: _todo.id);
                      },
                      child: Image.asset(
                        AppIcons.back,
                        height: 60,
                        width: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  initialValue: _todo.name,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Iltimos, event nomini kiriting.';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _todo.name = newValue!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Izoh',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 140,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  initialValue: _todo.description,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Iltimos, izoh kiriting.';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _todo.description = newValue!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sana',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _todo.date != null
                                          ? DateFormat("EEEE, d MMMM, yyy")
                                              .format(_todo.date as DateTime)
                                          : '',
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _planAddDate(context);
                                      },
                                      child: const Text("KALENDAR"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
      bottomSheet: InkWell(
        onTap: () {
          _saveForm();
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.appGreen,
          ),
          child: const Text(
            'Tasdiqlash',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
