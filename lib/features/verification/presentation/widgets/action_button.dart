import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_state.dart';

class ActionButtons extends StatelessWidget {
  final VerificationState state;

  const ActionButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isprocessing || state.hascaptured) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () => context.read<VerificationCubit>().capturePhoto(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainTextColorBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 24.sp),
            horizontalSpace(12),
            Text(
              'Capture Photo',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}