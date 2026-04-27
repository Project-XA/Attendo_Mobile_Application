import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_info_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        final user = context.read<CurrentUserCubit>().currentUser;
        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile.personal_information'.tr(),
                style: AppTextStyle.font18BlackBold.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              verticalSpace(15.h),
              FullNameCard(fullName: user.fullName),
              verticalSpace(12.h),
              if (user.email != null) EmailCard(email: user.email!),
              verticalSpace(12.h),
              CollageCardId(
                collageCardId:
                    user.collegeCardId ?? 'profile.not_available'.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}
