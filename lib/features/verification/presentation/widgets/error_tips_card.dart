import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/verification/presentation/widgets/tip_item.dart';

class ErrorTipsCard extends StatelessWidget {
  final List<String> tips;

  const ErrorTipsCard({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue.shade700,
                size: 20.sp,
              ),
              horizontalSpace(8),
              Text(
                'Tips:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          ...tips.map((tip) => TipItem(text: tip)),
        ],
      ),
    );
  }
}