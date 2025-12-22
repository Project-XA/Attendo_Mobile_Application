// feature/home/presentation/admin/home/presentation/admin_home.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_admin_home.dart'; // ✅ Import this
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/admin_home_shimmer.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/manage_session_view.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/user_attendency_view.dart';
import 'package:mobile_app/feature/home/presentation/widgets/info_card.dart';
import 'package:mobile_app/feature/home/presentation/widgets/toggle_taps.dart';
import 'package:mobile_app/feature/home/presentation/widgets/user_header.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    // ✅ Initialize dependencies synchronously before building
    initAdminHome();

    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..loadUser(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading || state is AdminInitial) {
              return const AdminHomeShimmer();
            }

            if (state is AdminError) {
              return _buildErrorView(context);
            }

            // ✅ Get user from state
            final user = state is AdminUserLoaded
                ? state.user
                : state is ToggleTabChanged
                ? state.user
                : null;

            if (user == null) {
              return const Center(child: Text('No user data'));
            }

            return SafeArea(
              child: Column(
                children: [
                  UserHeader(
                    userName: user.fullNameEn,
                    userRole: user.organizations?.first.role ?? 'Admin',
                    userImage: user.profileImage ?? Assets.assetsImagesUser,
                    notificationCount: 5,
                    onNotificationTap: () {},
                  ),

                  verticalSpace(20),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.w : 20.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      children: [
                        const InfoCard(
                          title: 'Admin Control Panel',
                          subtitle: 'Assuit University',
                          description: 'Unique sessions and attendance',
                        ),

                        verticalSpace(16.h),

                        _buildToggleTabs(),
                      ],
                    ),
                  ),

                  Expanded(child: _buildContent()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          verticalSpace(16.h),
          Text('Failed to load user data', style: TextStyle(fontSize: 16.sp)),
          verticalSpace(16.h),
          ElevatedButton(
            onPressed: () => context.read<AdminCubit>().loadUser(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs() {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final selectedIndex = state is ToggleTabChanged
            ? state.selectedIndex
            : 0;

        return ToggleTabs(
          tabs: const ["Manage Sessions", "User Attendance"],
          selectedIndex: selectedIndex,
          onTabSelected: (index) => context.read<AdminCubit>().changeTab(index),
        );
      },
    );
  }

  Widget _buildContent() {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final selectedIndex = state is ToggleTabChanged
            ? state.selectedIndex
            : 0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: IndexedStack(
            index: selectedIndex,
            children: const [ManageSessionsView(), UserAttendanceView()],
          ),
        );
      },
    );
  }
}
