import 'package:flutter/material.dart';
import '../constants/Colors.dart';
import '../constants/icons.dart';
import '../models/todo.dart';
import '../screens/add_todo.dart';
import '../screens/home.dart';

// ignore: must_be_immutable
class DetailsContainer extends StatelessWidget {
  Todo todo;

  DetailsContainer({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      height: 268,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.appGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AddTodoScreen.routeName,
                    arguments: todo.id,
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      AppIcons.edit,
                      height: 16,
                      width: 16,
                      fit: BoxFit.cover,
                      color: Colors.white,
                    ),
                    const Text(
                      'O\'zgartirish',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              todo.name,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
