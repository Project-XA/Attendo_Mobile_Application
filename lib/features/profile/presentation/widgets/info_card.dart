import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 24.sp),
          ),
          horizontalSpace(15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.font14GreyMedium.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                verticalSpace(4.h),
                Text(value, style: AppTextStyle.font15BlackMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.onSurface,
                size: 22.sp,
              ),
              tooltip: 'profile.edit_tooltip'.tr(),
            )
          else
            Icon(Icons.lock_outline, color: Colors.grey[400], size: 20.sp),
        ],
      ),
    );
  }
}