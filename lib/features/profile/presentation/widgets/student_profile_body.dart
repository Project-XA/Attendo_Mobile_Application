import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/profile/presentation/widgets/info_card.dart';

class StudentProfileBody extends StatelessWidget {
  const StudentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentStudentCubit, CurrentStudentState>(
      builder: (context, state) {
        final student = state.student;
        if (student == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile.personal_information'.tr(),
                style: AppTextStyle.font18Bold.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              verticalSpace(15.h),
              InfoCard(
                icon: Icons.person,
                label: 'profile.field_full_name'.tr(),
                value: student.fullName,
              ),
              verticalSpace(12.h),
              InfoCard(
                icon: Icons.badge_outlined,
                label: 'profile.field_roll_number'.tr(),
                value: student.rollNumber,
              ),
              verticalSpace(12.h),
              InfoCard(
                icon: Icons.school_outlined,
                label: 'profile.field_organization'.tr(),
                value: student.organizationName,
              ),
              verticalSpace(12.h),
              InfoCard(
                icon: Icons.email_outlined,
                label: 'profile.field_email'.tr(),
                value: student.email,
              ),
            ],
          ),
        );
      },
    );
  }
}
