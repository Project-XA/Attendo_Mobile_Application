// verification_failed_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/features/verification/presentation/widgets/error_tips_card.dart';
import 'package:mobile_app/features/verification/presentation/widgets/retry_button.dart';
import 'package:mobile_app/features/verification/presentation/widgets/state_icon.dart';

class VerificationFailedState extends StatelessWidget {
  const VerificationFailedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusIcon(
                icon: Icons.person_off_outlined,
                color: Colors.red,
                backgroundColor: Colors.red.shade50,
              ),
              verticalSpace(32),
              Text(
                'Identity Verification Failed',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(12),
              Text(
                'The face in your selfie doesn\'t match the photo on your ID card.',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(25),

              const ErrorTipsCard(
                tips: [
                  'Make sure you\'re the same person in the ID',
                  'Ensure good lighting on your face',
                  'Remove glasses or face coverings',
                  'Face the camera directly',
                  'Make sure your entire face is visible',
                ],
              ),

              verticalSpace(25),
              RetryButton(
                onPressed: () =>
                    context.read<VerificationCubit>().retryCapture(),
              ),

              verticalSpace(16),
            ],
          ),
        ),
      ),
    );
  }
}
