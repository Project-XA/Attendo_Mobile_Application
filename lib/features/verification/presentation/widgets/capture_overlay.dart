import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class CapturedOverlay extends StatelessWidget {
  const CapturedOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 320.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '68%',
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.backGroundColorWhite,
              shadows: const [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          verticalSpace(8),
          Text(
            'Processing...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.backGroundColorWhite,
              fontWeight: FontWeight.w500,
              shadows: const [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
