import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const FieldLabel({
    super.key,
    required this.label,
    required this.icon,
  });
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    children: [
      Icon(
        icon,
        size: 18.sp,
        color: colorScheme.onSurface.withOpacity(0.7),
      ),
      horizontalSpace(6.w),
      Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeightHelper.semiBold,
          color: colorScheme.onSurface,
        ),
      ),
    ],
  );
}
}