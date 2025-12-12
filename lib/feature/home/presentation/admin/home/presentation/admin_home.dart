import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      body: SafeArea(child: Column(children: [
        Container(
          color: AppColors.buttonColorBlue,
          
          
        ),
      ])),
    );
  }
}
