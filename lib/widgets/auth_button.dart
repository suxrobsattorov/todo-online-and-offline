import 'package:flutter/material.dart';

import '../constants/Colors.dart';

// ignore: must_be_immutable
class AuthButton extends StatelessWidget {
  String name;

  AuthButton({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: AppColors.appGreen,
          ),
        ],
        color: AppColors.appGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
