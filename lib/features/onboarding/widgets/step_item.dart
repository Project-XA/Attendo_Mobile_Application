import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class StepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const StepItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32.sp, color: Theme.of(context).colorScheme.onSurface),
          horizontalSpace(16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.font18BlackBold.copyWith(color: Theme.of(context).colorScheme.onSurface)),

              verticalSpace(4),

              Text(subtitle, style: AppTextStyle.font14GreyRegular.copyWith(color: Theme.of(context).colorScheme.outline)),
            ],
          ),
        ],
      ),
    );
  }
}