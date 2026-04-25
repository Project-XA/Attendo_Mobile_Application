import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeightHelper.semiBold,
          color: AppColors.buttonBlueColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}