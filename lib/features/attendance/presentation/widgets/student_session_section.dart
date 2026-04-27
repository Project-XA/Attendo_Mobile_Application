import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/chech_in_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/discover/discover_cubit.dart';
import 'package:mobile_app/features/attendance/presentation/logic/discover/discover_state.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/active_session_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/no_session_card.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/searching_session_card.dart';

class StudentSessionSection extends StatelessWidget {
  final DiscoveryCubit discoveryCubit;
  final CheckInCubit checkInCubit;

  const StudentSessionSection({
    super.key,
    required this.discoveryCubit,
    required this.checkInCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, discoveryState) {
        if (discoveryState is DiscoverySearching) {
          return SearchingSessionsCard(
            totalSearchDuration: 30,
            onTimeout: () => discoveryCubit.stopSearch(),
            onCancel: () => discoveryCubit.stopSessionDiscovery(),
          );
        }

        if (discoveryState is DiscoverySessionFound) {
          return ActiveSessionCard(
            session: discoveryState.activeSession,
            onCheckIn: (session) {
              final student = context.read<CurrentStudentCubit>().state.student!;
              checkInCubit.checkIn(
                session,
                userId: student.appUserId,
                userName: student.fullName,
              );
            },
          );
        }

        return NoSessionsCard(
          isIdle: discoveryState is DiscoveryIdle,
          isDiscoveryActive: discoveryState is DiscoveryTimeout,
          onSearch: () => discoveryCubit.startSessionDiscovery(),
          onRefresh: () => discoveryCubit.refreshSessions(),
        );
      },
    );
  }
}