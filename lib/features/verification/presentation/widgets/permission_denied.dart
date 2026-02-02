import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';

class PermissionDeniedState extends StatelessWidget {
  const PermissionDeniedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 100.sp,
              color: Colors.grey[400],
            ),
            verticalSpace(24),
            Text(
              'Camera Access Required',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              'We need access to your camera to verify your identity',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(32),
            ElevatedButton(
              onPressed: () => context.read<VerificationCubit>().opencamera(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Grant Permission',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.backGroundColorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
