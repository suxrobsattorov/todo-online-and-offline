import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_task/provider/todos.dart';

import '../constants/icons.dart';
import '../models/todo.dart';
import '../widgets/details_container.dart';
import 'home.dart';

class DetailsTodoScreen extends StatefulWidget {
  const DetailsTodoScreen({Key? key}) : super(key: key);

  static const routeName = '/details';

  @override
  State<DetailsTodoScreen> createState() => _DetailsTodoScreenState();
}

class _DetailsTodoScreenState extends State<DetailsTodoScreen> {
  Todo? todo;

  @override
  Widget build(BuildContext context) {
    final todoId = ModalRoute.of(context)!.settings.arguments;
    final todo =
        Provider.of<Todos>(context, listen: false).findById(todoId as String);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsContainer(
            todo: todo,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ihoh',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            todo.description,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Provider.of<Todos>(context, listen: false)
                          .deleteTodo(todoId);
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color(0xFFFEE8E9),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppIcons.delete,
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'O\'chirish',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
