// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/server_info_card.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/session_info_card.dart';

class ActiveSessionView extends StatelessWidget {
  final Session session;
  final ServerInfo serverInfo;

  const ActiveSessionView({
    super.key,
    required this.session,
    required this.serverInfo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionManagementCubit, SessionManagementState>(
      listener: (context, state) {
        if (state is SessionState && state.showWarning) {
          _showWarningSnackBar(context);
        }

        if (state is SessionState && state.isDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.delete_outline,
                    color: AppColors.mainBackgroundWhiteColor,
                  ),
                  horizontalSpace(12.w),
                  Expanded(child: Text('sessions.session_deleted_snack'.tr())),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<SessionManagementCubit, SessionManagementState>(
              builder: (context, state) {
                if (state is SessionState && state.showWarning) {
                  return SliverToBoxAdapter(child: _buildWarningBanner());
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            SliverToBoxAdapter(child: SessionInfoCard(session: session)),
            SliverToBoxAdapter(child: verticalSpace(10)),
            SliverToBoxAdapter(child: ServerInfoCard(serverInfo: serverInfo)),
            SliverToBoxAdapter(child: verticalSpace(20)),

            SliverToBoxAdapter(child: _buildActionButtons(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade300, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.sp),
          horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sessions.session_ending_banner_title'.tr(),
                  style: AppTextStyle.font16Orange900Bold,
                ),
                verticalSpace(4.h),
                Text(
                  'sessions.session_ending_banner_subtitle'.tr(),
                  style: AppTextStyle.font13Orange700Medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWarningSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.mainBackgroundWhiteColor,
            ),
            horizontalSpace(12.w),
            Expanded(
              child: Text(
                'sessions.session_end_snack'.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'common.ok'.tr(),
          textColor: AppColors.mainBackgroundWhiteColor,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Expanded(
            child: CustomAppButton(
              onPressed: () => _showEndSessionDialog(context),
              backgroundColor: colorScheme.primary, // ✅ already correct
              borderRadius: 20.r,
              height: 45.h,
              child: Text(
                'sessions.end_session'.tr(),
                style: AppTextStyle.font16WhiteMedium,
              ),
            ),
          ),
          horizontalSpace(12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => _showDeleteSessionDialog(context),
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'common.delete'.tr(),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 24.sp),
            horizontalSpace(8.w),
            Flexible(
              child: Text(
                'sessions.end_session_title'.tr(),
                style: AppTextStyle.font18BlackSemiBold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'sessions.end_session_confirm'.tr(
              args: ['${session.attendanceList.length}'],
            ),
            style: AppTextStyle.font14GreyRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'common.cancel'.tr(),
              style: AppTextStyle.font14GreyRegular,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SessionManagementCubit>().endSession();
            },
            child: Text(
              'sessions.end_save'.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24.sp),
            horizontalSpace(8.w),
            Flexible(
              child: Text(
                'sessions.delete_session_title'.tr(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'sessions.delete_session_confirm'.tr(
              args: ['${session.attendanceList.length}'],
            ),
            style: AppTextStyle.font14GreyRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'common.cancel'.tr(),
              style: AppTextStyle.font14BlackRegular,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SessionManagementCubit>().deleteSession();
            },
            child: Text(
              'common.delete'.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
