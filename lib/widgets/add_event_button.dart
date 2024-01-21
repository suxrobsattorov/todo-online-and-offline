import 'package:flutter/material.dart';

import '../constants/Colors.dart';
import '../screens/add_todo.dart';

class AddTodoButton extends StatelessWidget {
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Ro\'yhat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(AddTodoScreen.routeName),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.appGreen,
            ),
            child: const Text(
              '+ Add Todo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
