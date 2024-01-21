import 'package:flutter/material.dart';

import '../constants/Colors.dart';
import '../constants/images.dart';

class MainImage extends StatelessWidget {
  const MainImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appGreen2,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(AppImages.todoImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
