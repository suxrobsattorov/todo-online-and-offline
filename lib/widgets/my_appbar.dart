import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../constants/images.dart';
import '../provider/auth.dart';
import '../screens/auth_screen.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 28),
        Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            image: const DecorationImage(
              image: AssetImage(AppImages.todoLogo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Provider.of<Auth>(context, listen: false).lodOut();
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          },
          child: Image.asset(
            AppIcons.leave,
            height: 25,
            width: 25,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}
