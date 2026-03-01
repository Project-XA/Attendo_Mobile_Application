// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/services/auth/authentication_manager.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/features/attendance/data/services/check_in_handler.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_state.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/active_session_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/attendence_status_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/check_in_view.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/no_session_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/searching_session_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/user_dashboard_shimmer.dart';
import 'package:mobile_app/core/widgets/info_card.dart';
import 'package:mobile_app/core/widgets/user_header.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboardScreen> {
  late final CheckInHandler _checkInHandler;

  @override
  void initState() {
    super.initState();
    _checkInHandler = CheckInHandler(
      authManager: getIt<AuthenticationManager>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return BlocProvider(
      create: (context) => getIt<UserCubit>()..loadStats(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, attendanceState) {
            final currentUserCubit = context.read<CurrentUserCubit>();
            final user = currentUserCubit.currentUser;

            if (attendanceState is UserLoading ||
                attendanceState is UserInitial ||
                user == null) {
              return const UserDashboardShimmer();
            }

            if (attendanceState is UserError) {
              return _buildErrorView(context, attendanceState.message);
            }

            return SafeArea(
              child: Column(
                children: [
                  BlocBuilder<CurrentUserCubit, CurrentUserState>(
                    builder: (context, userState) {
                      final latestUser = currentUserCubit.currentUser;
                      return UserHeader(
                        userName: latestUser?.fullNameEn ?? '',
                        userRole:
                            latestUser?.organizations?.first.role ?? 'Student',
                        userImage:
                            latestUser?.profileImage ?? Assets.assetsImagesUser,
                      );
                    },
                  ),
                  verticalSpace(20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.w : 20.w,
                      vertical: 8.h,
                    ),
                    child: InfoCard(
                      title: 'Welcome Back!',
                      subtitle:
                          user.organizations?.first.organizationName ?? '',
                      description: 'Check attendance and active sessions',
                    ),
                  ),
                  verticalSpace(20.h),
                  Expanded(child: _buildContent(context, attendanceState)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          verticalSpace(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ),
          verticalSpace(16.h),
          ElevatedButton(
            onPressed: () => context.read<UserCubit>().loadStats(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    if (state is CheckInState) {
      return CheckInView(state: state);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActiveSessionCard(context, state),
          verticalSpace(20.h),
          _buildMyAttendanceSection(context, state),
          verticalSpace(20.h),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(BuildContext context, UserState state) {
    final hasActiveSession =
        state is SessionDiscoveryActive &&
        (state.activeSession != null || state.discoveredSessions.isNotEmpty) &&
        !state.isSearching;

    final isSearching = state is SessionDiscoveryActive && state.isSearching;

    if (isSearching) {
      return SearchingSessionsCard(
        totalSearchDuration: 30,
        onTimeout: () => context.read<UserCubit>().stopSearch(),
      );
    }

    if (hasActiveSession) {
      final session = state.activeSession ?? state.discoveredSessions.first;
      return ActiveSessionCard(
        session: session,
        checkInHandler: _checkInHandler,
      );
    }

    return NoSessionsCard(
      isIdle: state is UserIdle,
      isDiscoveryActive: state is SessionDiscoveryActive,
    );
  }

  Widget _buildMyAttendanceSection(BuildContext context, UserState state) {
    final stats = _getStatsFromState(state);
    final hasError = _getErrorStateFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Attendance',
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
          ],
        ),
        verticalSpace(12.h),
        AttendanceStatsCard(
          stats: stats,
          hasError: hasError,
          onRetry: () => context.read<UserCubit>().loadStats(),
        ),
      ],
    );
  }

  AttendanceStats? _getStatsFromState(UserState state) {
    return state is UserStateWithStats ? state.stats : null;
  }

  bool _getErrorStateFromState(UserState state) {
    return state is UserStateWithStats ? state.hasStatsError : false;
  }
}
