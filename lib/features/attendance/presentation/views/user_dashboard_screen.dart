import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/chech_in_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/check_in_state.dart';
import 'package:mobile_app/features/attendance/presentation/logic/discover/discover_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/discover/discover_state.dart';
import 'package:mobile_app/features/attendance/presentation/logic/stats/stats_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/stats/stats_state.dart';
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
  late final StatsCubit _statsCubit;
  late final DiscoveryCubit _discoveryCubit;
  late final CheckInCubit _checkInCubit;

  @override
  void initState() {
    super.initState();
    _statsCubit = getIt<StatsCubit>();
    _discoveryCubit = getIt<DiscoveryCubit>();
    _checkInCubit = getIt<CheckInCubit>();
    _statsCubit.loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _statsCubit),
        BlocProvider.value(value: _discoveryCubit),
        BlocProvider.value(value: _checkInCubit),
      ],
      child: BlocListener<CheckInCubit, CheckInState>(
        listener: _onCheckInStateChanged,
        child: Scaffold(body: _buildBody()),
      ),
    );
  }

  void _onCheckInStateChanged(BuildContext context, CheckInState state) {
    if (state is CheckInSuccess) {
      _statsCubit.refreshStats();
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _checkInCubit.reset();
        _discoveryCubit.stopSessionDiscovery();
      });
    }

    if (state is CheckInFailed) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _checkInCubit.reset();
        _discoveryCubit.startSessionDiscovery();
      });
    }
  }

  Widget _buildBody() {
    return BlocBuilder<CheckInCubit, CheckInState>(
      builder: (context, checkInState) {
        if (checkInState is! CheckInIdle) {
          return CheckInView(state: checkInState);
        }

        return BlocBuilder<StatsCubit, StatsState>(
          builder: (context, statsState) {
            final user = context.read<CurrentUserCubit>().currentUser;

            if (statsState is StatsInitial ||
                statsState is StatsLoading ||
                user == null) {
              return const UserDashboardShimmer();
            }

            final isSmallScreen = MediaQuery.of(context).size.width < 360;
            final orgName = user.organizations?.first.organizationName?.trim();
            final orgSubtitle = (orgName != null && orgName.isNotEmpty)
                ? orgName
                : 'attendance.organization_placeholder'.tr();

            return SafeArea(
              child: Column(
                children: [
                  BlocBuilder<CurrentUserCubit, CurrentUserState>(
                    builder: (context, _) {
                      final latestUser = context
                          .read<CurrentUserCubit>()
                          .currentUser;
                      return UserHeader(
                        userName: latestUser?.fullName ?? '',
                        userRole:
                            latestUser?.organizations?.first.role ??
                            'attendance.default_role_student'.tr(),
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
                      title: 'attendance.welcome_title'.tr(),
                      subtitle: orgSubtitle,
                      description: 'attendance.welcome_description'.tr(),
                    ),
                  ),
                  verticalSpace(20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildActiveSessionCard(context),
                          verticalSpace(20.h),
                          _buildMyAttendanceSection(statsState),
                          verticalSpace(20.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActiveSessionCard(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, discoveryState) {
        if (discoveryState is DiscoverySearching) {
          return SearchingSessionsCard(
            totalSearchDuration: 30,
            onTimeout: () => _discoveryCubit.stopSearch(),
            onCancel: () => _discoveryCubit.stopSessionDiscovery(),
          );
        }

        if (discoveryState is DiscoverySessionFound) {
          return ActiveSessionCard(
            session: discoveryState.activeSession,
            onCheckIn: (session) {
              final user = context.read<CurrentUserCubit>().currentUser!;
              _checkInCubit.checkIn(
                session,
                userId: user.id!,
                userName: user.fullName,
              );
            },
          );
        }

        return NoSessionsCard(
          isIdle: discoveryState is DiscoveryIdle,
          isDiscoveryActive: discoveryState is DiscoveryTimeout,
          onSearch: () => _discoveryCubit.startSessionDiscovery(),
          onRefresh: () => _discoveryCubit.refreshSessions(),
        );
      },
    );
  }

  Widget _buildMyAttendanceSection(StatsState statsState) {
    final stats = statsState is StatsLoaded ? statsState.stats : null;
    final hasError = statsState is StatsLoaded ? statsState.hasError : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'attendance.my_attendance'.tr(),
              style: AppTextStyle.font18GreyBold,
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(Routes.userAnalysisScreen);
              },
              child: Text("View more", style: AppTextStyle.font18GreyBold),
            ),
          ],
        ),
        verticalSpace(12.h),
        AttendanceStatsCard(
          stats: stats,
          hasError: hasError,
          onRetry: () => _statsCubit.loadStats(),
        ),
      ],
    );
  }
}
