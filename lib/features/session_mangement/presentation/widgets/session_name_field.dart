import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class SessionNameField extends StatelessWidget {
  final TextEditingController controller;

  const SessionNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppTextFormField(
      borderRadius: 20.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      focusedBorderColor: colorScheme.onSurface,
      enabledBorderColor: colorScheme.outline,
      controller: controller,
      hintText: 'sessions.hint_session_name'.tr(),
      labelStyle: AppTextStyle.font14GreyMedium,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'sessions.val_session_name_required'.tr();
        }
        return null;
      },
    );
  }
}