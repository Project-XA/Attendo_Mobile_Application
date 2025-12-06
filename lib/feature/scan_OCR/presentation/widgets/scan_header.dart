import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class ScanHeader extends StatelessWidget {
  const ScanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scan Your ID",
          style: AppTextStyle.font18BoldBlack.copyWith(fontSize: 24.sp),
        ),
        verticalSpace(10),
        Text(
          "Please scan your ID to confirm verification process.",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.sp, color: AppColors.subTextColorGrey),
        ),
      ],
    );
  }
}
