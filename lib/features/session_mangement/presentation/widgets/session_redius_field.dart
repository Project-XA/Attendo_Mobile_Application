import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class SessionRadiusField extends StatelessWidget {
  final TextEditingController controller;

  const SessionRadiusField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('sessions.radius_section'.tr(),
            style: AppTextStyle.font12GreyBold),
        verticalSpace(8.h),
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          focusedBorderColor: colorScheme.onSurface,
          enabledBorderColor: colorScheme.outline,
          controller: controller,
          hintText: '50',
          keyboardType: TextInputType.number,
          labelStyle: AppTextStyle.font14GreyMedium,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'sessions.val_radius_required'.tr();
            }
            final radius = double.tryParse(value);
            if (radius == null || radius <= 0) {
              return 'sessions.val_radius_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}