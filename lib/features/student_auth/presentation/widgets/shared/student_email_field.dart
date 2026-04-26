import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class StudentEmailField extends StatelessWidget {
  final TextEditingController controller;

  const StudentEmailField({super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'loginStudent.email_label'.tr(),
          style: AppTextStyle.font14GreyMedium,
        ),
        verticalSpace(8),
         AppTextFormField(
                controller: controller,
                hintText: 'loginStudent.email_hint'.tr(),
                borderRadius: 14.r,
                backgroundColor:AppColors.onDarkForegroundWhiteColor,
                enabledBorderColor: AppColors.onDarkForegroundWhiteColor,
                focusedBorderColor: AppColors.mainBackgroundDarkColor,
                textStyle: TextStyle(
                  color: AppColors.mainBackgroundDarkColor,
                  fontSize: 14.sp,
                ),
                keyboardType: TextInputType.emailAddress,
                label: const Icon(
                  Icons.email_outlined,
                  color: AppColors.onDarkForegroundWhiteColor,
                  size: 20,
                ),
                validator: (val) => val == null || !val.contains('@')
                    ? 'validation.enter_valid_email'.tr()
                    : null,
              ),
      ],
    );
  }
}