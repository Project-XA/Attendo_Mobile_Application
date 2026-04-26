import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_register_widgets/register_form.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainBackgroundWhiteColor,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'Attendo', style: AppTextStyle.font18BlackBold),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.mainBackgroundDarkColor,
            size: 18,
          ),
        ),
      ),
     body: SingleChildScrollView(
  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpace(12),
      Text(
        'registerStudent.create_account'.tr(),
        style: AppTextStyle.font24BlackBold,
      ),
      verticalSpace(8),
      Text(
        'registerStudent.subtitle'.tr(),
        style: TextStyle(
          color: AppColors.subTextGreyColor,
          fontSize: 14.sp,
          fontWeight: FontWeightHelper.regular,
        ),
      ),
      verticalSpace(16),

      // ── Student Badge ─────────────────────────────────────
      Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.mainBackgroundDarkColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.mainBackgroundDarkColor.withOpacity(0.12),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: AppColors.mainBackgroundDarkColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.person_add_rounded,
                size: 16.sp,
                color: AppColors.mainBackgroundWhiteColor,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'registerStudent.portal_badge'.tr(),
                  style: TextStyle(
                    color: AppColors.mainBackgroundDarkColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeightHelper.semiBold,
                  ),
                ),
                Text(
                  'registerStudent.portal_badge_sub'.tr(),
                  style: TextStyle(
                    color: AppColors.subTextGreyColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeightHelper.regular,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      verticalSpace(28),
      RegisterForm(formKey: _formKey),
    ],
  ),
),
    );
  }
}
