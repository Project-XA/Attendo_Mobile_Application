import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/profile/presentation/widgets/student_profile_image_section.dart';

class StudentTopSection extends StatelessWidget {
  const StudentTopSection({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentStudentCubit, CurrentStudentState>(
      builder: (context, state) {
        final student = state.student;
        if (student == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2C)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'profile.title'.tr(),
                        style: AppTextStyle.font20WhiteBold,
                      ),
                      ValueListenableBuilder(
                        valueListenable: drawerController,
                        builder: (_, value, __) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: IconButton(
                              key: ValueKey(value.visible),
                              icon: Icon(
                                value.visible
                                    ? Icons.close_rounded
                                    : Icons.menu_rounded,
                                color: AppColors.mainBackgroundWhiteColor,
                                size: 26.sp,
                              ),
                              onPressed: drawerController.toggleDrawer,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  verticalSpace(16.h),
                  const StudentProfileImageSection(),
                  verticalSpace(10.h),
                  // Full Name
                  Text(student.fullName, style: AppTextStyle.font22WhiteBold),
                  verticalSpace(5.h),
                  // Email
                  Text(student.email, style: AppTextStyle.font14WhiteMedium),
                  verticalSpace(5.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                        horizontalSpace(4.w),
                        Text(
                          student.rollNumber,
                          style: AppTextStyle.font12WhiteMedium,
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(8.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}