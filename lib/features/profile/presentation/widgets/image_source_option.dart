import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ImageSourceOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40.sp, color: Theme.of(context).colorScheme.onSurface),
            verticalSpace(8.h),
            Text(label, style: AppTextStyle.font14GreyMedium),
          ],
        ),
      ),
    );
  }
}