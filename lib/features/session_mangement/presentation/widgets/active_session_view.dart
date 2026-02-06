// ignore_for_file: deprecated_member_use
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
    return BlocListener<SessionMangementCubit, SessionManagementState>(
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
                    color: AppColors.backGroundColorWhite,
                  ),
                  horizontalSpace(12.w),
                  const Expanded(
                    child: Text(
                      'Session deleted successfully without saving attendance',
                    ),
                  ),
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
            BlocBuilder<SessionMangementCubit, SessionManagementState>(
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
                  '⏰ Session Ending Soon',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                verticalSpace(4.h),
                Text(
                  'Only 5 minutes remaining until auto-close',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 13.sp,
                    color: Colors.orange.shade700,
                  ),
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
              color: AppColors.backGroundColorWhite,
            ),
            horizontalSpace(12.w),
            Expanded(
              child: Text(
                '⏰ Session will end in 5 minutes!',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: AppColors.backGroundColorWhite,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          // End Session Button
          Expanded(
            child: CustomAppButton(
              onPressed: () => _showEndSessionDialog(context),
              backgroundColor: AppColors.mainTextColorBlack,
              borderRadius: 20.r,
              height: 45.h,
              child: Text(
                'End Session',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  color: AppColors.backGroundColorWhite,
                  fontWeight: FontWeightHelper.medium,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),

          horizontalSpace(12.w),

          // Delete Session Button
          Expanded(
            child: GestureDetector(
              onTap: () => _showDeleteSessionDialog(context),
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: AppColors.backGroundColorWhite,
                  border: Border.all(
                    color: AppColors.mainTextColorBlack,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Delete',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: AppColors.mainTextColorBlack,
                    fontWeight: FontWeightHelper.medium,
                    fontSize: 16.sp,
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
        backgroundColor: AppColors.backGroundColorWhite,
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 24.sp),
            horizontalSpace(8.w),
            Flexible(
              child: Text(
                'End Session',
                style: TextStyle(
                  color: AppColors.mainTextColorBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'Are you sure you want to end this session?\n\n'
            '✓ ${session.attendanceList.length} attendees will be saved\n'
            '✓ Attendance data will be recorded',
            style: TextStyle(
              color: AppColors.subTextColorGrey,
              fontSize: 14.sp,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.subTextColorGrey,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SessionMangementCubit>().endSession();
            },
            child: Text('End & Save', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  void _showDeleteSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backGroundColorWhite,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24.sp),
            horizontalSpace(8.w),
            Flexible(
              child: Text(
                'Delete Session',
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
            'Are you sure you want to delete this session?\n\n'
            '⚠️ ${session.attendanceList.length} attendees will NOT be saved\n'
            '⚠️ All attendance data will be lost\n'
            '⚠️ This action cannot be undone',
            style: TextStyle(
              color: AppColors.subTextColorGrey,
              fontSize: 14.sp,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.mainTextColorBlack,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SessionMangementCubit>().deleteSession();
            },
            child: Text('Delete', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}
