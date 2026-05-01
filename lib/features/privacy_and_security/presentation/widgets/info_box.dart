import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    required this.color,
    required this.textColor,
    required this.message,
    this.borderColor,
    super.key,
  });

  final Color color;
  final Color textColor;
  final String message;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 0.5)
            : null,
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 12.sp, color: textColor, height: 1.6),
      ),
    );
  }
}