import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/chech_in_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/check_in_state.dart';
import 'package:mobile_app/features/attendance/presentation/logic/discover/discover_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/stats/stats_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/stats/stats_state.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/check_in_view.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/student_attendance_section.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/student_header.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/student_info_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/student_session_section.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/user_dashboard_shimmer.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
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
        child: Scaffold(
          body: _buildBody(),
        ),
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
            final student = context.read<CurrentStudentCubit>().state.student;

            if (statsState is StatsInitial ||
                statsState is StatsLoading ||
                student == null) {
              return const UserDashboardShimmer();
            }

            final isSmallScreen = MediaQuery.of(context).size.width < 360;

            return SafeArea(
              child: Column(
                children: [
                  BlocBuilder<CurrentStudentCubit, CurrentStudentState>(
                    builder: (context, _) {
                      final latestStudent =
                          context.read<CurrentStudentCubit>().state.student;
                      return StudentHeader(
                        userName: latestStudent?.fullName ?? '',
                        rollNumber: latestStudent?.rollNumber ?? '',
                        userImage: latestStudent?.profileImage,
                      );
                    },
                  ),
                  verticalSpace(20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.w : 20.w,
                      vertical: 8.h,
                    ),
                    child: StudentInfoCard(
                      organizationName: student.organizationName,
                      rollNumber: student.rollNumber,
                      email: student.email,
                    ),
                  ),
                  verticalSpace(20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StudentSessionSection(
                            discoveryCubit: _discoveryCubit,
                            checkInCubit: _checkInCubit,
                          ),
                          verticalSpace(20.h),
                          StudentAttendanceSection(
                            stats: statsState is StatsLoaded
                                ? statsState.stats
                                : null,
                            hasError: statsState is StatsLoaded
                                ? statsState.hasError
                                : false,
                            onRetry: () => _statsCubit.loadStats(),
                          ),
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
}