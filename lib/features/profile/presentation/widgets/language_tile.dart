import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.flag,
    required this.label,
    required this.locale,
  });

  final String flag;
  final String label;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = context.locale == locale;
    return InkWell(
      onTap: () {
        context.setLocale(locale);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.onSurface.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.onSurface
                : theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 20.sp)),
            horizontalSpace(12),
            Text(
              label,
              style: AppTextStyle.font14GreyMedium.copyWith(
                fontSize: 14.sp,
                fontWeight: isSelected
                    ? FontWeightHelper.semiBold
                    : FontWeightHelper.regular,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.onSurface,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}
