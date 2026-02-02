import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/verification/presentation/widgets/state_icon.dart';

class VerificationSuccessState extends StatelessWidget {
  const VerificationSuccessState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusIcon(
              icon: Icons.check_circle,
              color: Colors.green,
              backgroundColor: Colors.green.shade50,
            ),
            verticalSpace(32),
            Text(
              'Verification Done!',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              'Your identity has been successfully verified',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 3,
            ),
            verticalSpace(16),
            Text(
              'Redirecting to registration...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black45,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}