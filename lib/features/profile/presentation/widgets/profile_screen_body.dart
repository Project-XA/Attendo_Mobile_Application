import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/services/UI/toast_service.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/features/profile/presentation/widgets/top_section.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_body.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      body: BlocListener<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state.error != null) {
            showToast(message: state.error!, type: ToastType.error);
          }
        },
        child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
          builder: (context, state) {
            // Loading
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainTextColorBlack,
                ),
              );
            }

            final user = state.user;

            if (user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60.sp, color: Colors.grey),
                    verticalSpace(20.h),
                    Text(
                      'No user data found',
                      style: AppTextStyle.font14MediamGrey,
                    ),
                  ],
                ),
              );
            }

            return const Column(
              children: [
                TopSection(),
                Expanded(child: ProfileBody()),
              ],
            );
          },
        ),
      ),
    );
  }
}
