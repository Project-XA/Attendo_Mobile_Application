import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/features/verification/presentation/widgets/error_icon.dart';
import 'package:mobile_app/features/verification/presentation/widgets/error_tips_card.dart';
import 'package:mobile_app/features/verification/presentation/widgets/retry_button.dart';

class ErrorStateWidget extends StatelessWidget {
  final String? errorMessage;

  const ErrorStateWidget({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ErrorIcon(icon: errorInfo.icon, color: errorInfo.color),
            verticalSpace(24),
            Text(
              errorInfo.title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              errorMessage ?? 'An unexpected error occurred',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(32),
            RetryButton(
              onPressed: () => context.read<VerificationCubit>().retryCapture(),
            ),
            if (errorInfo.isFaceError) ...[
              verticalSpace(24),
              ErrorTipsCard(tips: errorInfo.tips),
            ],
          ],
        ),
      ),
    );
  }

  _ErrorInfo _getErrorInfo() {
    final isNoFace = errorMessage?.contains('No face') ?? false;
    final isMultipleFaces = errorMessage?.contains('Multiple') ?? false;
    final isLowConfidence = errorMessage?.contains('confidence') ?? false;

    if (isNoFace) {
      return _ErrorInfo(
        icon: Icons.face_retouching_off,
        color: Colors.orange,
        title: 'No Face Detected',
        isFaceError: true,
        tips: [
          'Ensure your face is centered in the frame',
          'Make sure there is good lighting',
          'Remove any objects covering your face',
        ],
      );
    } else if (isMultipleFaces) {
      return _ErrorInfo(
        icon: Icons.groups,
        color: Colors.orange,
        title: 'Multiple Faces Detected',
        isFaceError: true,
        tips: [
          'Ensure only your face is visible',
          'Ask others to step out of frame',
          'Use a plain background if possible',
        ],
      );
    } else if (isLowConfidence) {
      return _ErrorInfo(
        icon: Icons.visibility_off,
        color: Colors.orange,
        title: 'Face Not Clear',
        isFaceError: true,
        tips: [
          'Improve lighting conditions',
          'Hold the camera steady',
          'Face the camera directly',
        ],
      );
    } else {
      return _ErrorInfo(
        icon: Icons.error_outline,
        color: Colors.red.shade400,
        title: 'Something went wrong',
        isFaceError: false,
        tips: [],
      );
    }
  }
}

/// Error information data class
class _ErrorInfo {
  final IconData icon;
  final Color color;
  final String title;
  final bool isFaceError;
  final List<String> tips;

  _ErrorInfo({
    required this.icon,
    required this.color,
    required this.title,
    required this.isFaceError,
    required this.tips,
  });
}
