import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_cubit.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_state.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/history_section_content.dart';

/// Drop-in section widget. Place it inside the [_StatsBody] ListView.
/// It reads [UserAnalysisLoaded] from the nearest [UserAnalysisCubit]
/// and handles all history sub-states internally.
class AttendanceHistorySection extends StatelessWidget {
  const AttendanceHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAnalysisCubit, UserAnalysisState>(
      // Rebuild only when the loaded state changes — avoids full-screen rebuilds
      buildWhen: (prev, curr) =>
          curr is UserAnalysisLoaded &&
          (prev is! UserAnalysisLoaded ||
              (prev).history !=
                  (curr).history ||
              prev.isHistoryLoading != curr.isHistoryLoading ||
              prev.historyError != curr.historyError),
      builder: (context, state) {
        if (state is! UserAnalysisLoaded) return const SizedBox.shrink();

        return HistorySectionContent(state: state);
      },
    );
  }
}

