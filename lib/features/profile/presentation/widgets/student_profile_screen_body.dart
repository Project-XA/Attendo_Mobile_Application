import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/services/UI/toast_service.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/profile/presentation/widgets/student_profile_body.dart';
import 'package:mobile_app/features/profile/presentation/widgets/student_top_section.dart';

class StudentProfileScreenBody extends StatelessWidget {
  const StudentProfileScreenBody({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CurrentStudentCubit, CurrentStudentState>(
        listener: (context, state) {
          if (state.error != null) {
            showToast(message: state.error!, type: ToastType.error);
          }
        },
        child: BlocBuilder<CurrentStudentCubit, CurrentStudentState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainTextBlackColor,
                ),
              );
            }

            if (state.student == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60.sp, color: Colors.grey),
                    verticalSpace(20.h),
                    Text(
                      'profile.no_user_data'.tr(),
                      style: AppTextStyle.font14GreyMedium,
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: StudentTopSection(drawerController: drawerController),
                ),
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: StudentProfileBody(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}