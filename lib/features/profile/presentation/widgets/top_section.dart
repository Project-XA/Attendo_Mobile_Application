import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_image_section.dart';
import 'package:mobile_app/features/profile/presentation/widgets/user_info_section.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        final user = context.read<CurrentUserCubit>().currentUser;

        if (user == null) return const SizedBox.shrink();

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

                  // Profile Image
                  const ProfileImageSection(),

                  verticalSpace(10.h),

                  UserNameSection(fullNameEn: user.fullName),

                  verticalSpace(5.h),

                  if (user.email != null) UserEmailSection(email: user.email!),

                  verticalSpace(5.h),

                  if (user.organizations != null &&
                      user.organizations!.isNotEmpty)
                    UserRoleSection(role: user.organizations!.first.role),

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