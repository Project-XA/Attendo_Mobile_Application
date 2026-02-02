import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/features/verification/presentation/widgets/retry_button.dart';
import 'package:mobile_app/features/verification/presentation/widgets/state_icon.dart';

class VerificationFailedState extends StatelessWidget {
  const VerificationFailedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusIcon(
              icon: Icons.cancel,
              color: Colors.red,
              backgroundColor: Colors.red.shade50,
            ),
            verticalSpace(32),
            Text(
              'Verification Failed',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              'The face in the selfie doesn\'t match the ID card photo',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(40),
            RetryButton(
              onPressed: () =>
                  context.read<VerificationCubit>().retryCapture(),
            ),
          ],
        ),
      ),
    );
  }
}