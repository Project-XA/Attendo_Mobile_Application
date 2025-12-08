import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class ProcessingIndicator extends StatelessWidget {
  final bool isCardDetectionDone;
  final bool isFieldDetectionDone;
  final bool isDataExtractionDone;

  const ProcessingIndicator({
    super.key,
    required this.isCardDetectionDone,
    required this.isFieldDetectionDone,
    required this.isDataExtractionDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Processing ID Card...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          verticalSpace(20),
          _buildStep(title: 'Card Detection', isDone: isCardDetectionDone),
          verticalSpace(12),
          _buildStep(title: 'Field Detection', isDone: isFieldDetectionDone),
          verticalSpace(12),
          _buildStep(title: 'Data Extraction', isDone: isDataExtractionDone),
        ],
      ),
    );
  }

  Widget _buildStep({required String title, required bool isDone}) {
    return Row(
      children: [
        // Icon or Loading
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: isDone
              ? Icon(Icons.check_circle, color: Colors.green, size: 24.sp)
              : CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.mainTextColorBlack,
                  ),
                ),
        ),
        horizontalSpace(12),
        // Title
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDone
                  ? Colors.green.shade700
                  : AppColors.mainTextColorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
