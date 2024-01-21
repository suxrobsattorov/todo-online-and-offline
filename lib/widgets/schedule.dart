import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/Colors.dart';
import '../models/todo.dart';
import '../provider/todos.dart';

// ignore: must_be_immutable
class Schedule extends StatefulWidget {
  Color color1;
  Color color2;
  Todo todo;

  Schedule({
    Key? key,
    required this.color1,
    required this.color2,
    required this.todo,
  }) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.color1,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.color2,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.todo.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.watch_later,
                        size: 20,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat("EEEE, d MMMM, yyy")
                            .format(widget.todo.date as DateTime)
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Checkbox(
                value: widget.todo.isDone,
                onChanged: (value) async {
                  await Provider.of<Todos>(context, listen: false)
                      .updateTodoIsDone(widget.todo.id);
                  setState(() {});
                },
                shape: const CircleBorder(),
                activeColor: AppColors.appGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
