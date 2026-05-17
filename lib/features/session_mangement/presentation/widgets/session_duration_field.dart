import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class SessionDurationField extends StatelessWidget {
  final TextEditingController controller;

  const SessionDurationField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('sessions.duration_section'.tr(),
            style: AppTextStyle.font12GreyBold),
        verticalSpace(8.h),
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          focusedBorderColor: colorScheme.onSurface,
          enabledBorderColor: colorScheme.outline,
          controller: controller,
          hintText: '60',
          keyboardType: TextInputType.number,
          labelStyle: AppTextStyle.font14GreyMedium,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'sessions.val_duration_required'.tr();
            }
            final duration = int.tryParse(value);
            if (duration == null || duration <= 0) {
              return 'sessions.val_duration_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}