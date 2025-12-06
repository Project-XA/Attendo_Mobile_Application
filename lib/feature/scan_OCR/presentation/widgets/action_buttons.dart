import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class ActionButtons extends StatelessWidget {
  final CameraState state;

  const ActionButtons({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isProcessing) {
      return _buildProcessingIndicator();
    }

    if (state.showResult) {
      return _buildVerifyAndRetakeButtons(context);
    }

    if (!state.showResult &&
        state.photo != null &&
        !state.isProcessing &&
        state.hasCaptured) {
      return _buildInvalidPhotoSection(context);
    }

    return _buildCaptureButton(context);
  }

  // Processing Indicator
  Widget _buildProcessingIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.mainTextColorBlack.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.mainTextColorBlack,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "Processing...",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeightHelper.semiBold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
        ],
      ),
    );
  }

  // Verify & Retake Buttons
  Widget _buildVerifyAndRetakeButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomAppButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ID Verified Successfully!')),
              );
            },
            backgroundColor: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, color: Colors.white),
                horizontalSpace(8.w),
                Text(
                  "Verify",
                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: CustomAppButton(
            onPressed: () {
              context.read<CameraCubit>().retakePhoto();
            },
            backgroundColor: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  "Retake",
                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Invalid Photo Section
  Widget _buildInvalidPhotoSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "Invalid photo! Please capture a valid ID card.",
          style: TextStyle(color: Colors.red, fontSize: 14.sp),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: CustomAppButton(
            onPressed: () => context.read<CameraCubit>().retakePhoto(),
            backgroundColor: Colors.orange,
            child: Text(
              "Retake",
              style: AppTextStyle.font15SemiBoldWhite.copyWith(fontSize: 16.sp),
            ),
          ),
        ),
      ],
    );
  }

  // Capture Button
  Widget _buildCaptureButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomAppButton(
        onPressed: state.isOpened && !state.hasCaptured
            ? () => context.read<CameraCubit>().capturePhoto()
            : null,
        backgroundColor: state.isOpened && !state.hasCaptured
            ? AppColors.mainTextColorBlack
            : AppColors.subTextColorGrey.withOpacity(0.5),
        child: Text(
          "Capture",
          style: AppTextStyle.font15SemiBoldWhite.copyWith(fontSize: 16.sp),
        ),
      ),
    );
  }
}