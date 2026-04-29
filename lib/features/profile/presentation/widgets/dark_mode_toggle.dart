
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/themes/theme_cubit.dart';
import 'package:mobile_app/core/themes/theme_transition_manager.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({super.key,required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: Row(
        children: [
          Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: itemColor,
            size: 22.sp,
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              'settings.dark_mode'.tr(),
              style: AppTextStyle.font14GreyMedium.copyWith(
                color: itemColor,
                fontSize: 15.sp,
                fontWeight: FontWeightHelper.medium,
              ),
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (_) {
              ThemeTransitionManager.show(context: context, isDark: !isDark);
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}