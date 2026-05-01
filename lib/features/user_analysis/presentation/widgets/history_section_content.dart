import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/theme_cubit.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_cubit.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_state.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/attendance_history_item.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/empty_history_placeholder.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/history_error_banner.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/load_more.dart';

class HistorySectionContent extends StatelessWidget {
  final UserAnalysisLoaded state;

  const HistorySectionContent({required this.state , super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;
    final titleColor = isDark
        ? AppColors.mainTextDarkColor
        : AppColors.mainTextBlackColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            'Attendance History',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
        ),

        // ── Empty / first-load state ────────────────────────────────────────
        if (state.history.isEmpty && !state.isHistoryLoading)
          EmptyHistoryPlaceholder(isDark: isDark),

        // ── History items ───────────────────────────────────────────────────
        ...state.history.map(
          (record) => AttendanceHistoryItem(record: record),
        ),

        // ── Error under list (non-fatal, keeps existing items visible) ──────
        if (state.historyError != null)
          HistoryErrorBanner(
            message: state.historyError!,
            isDark: isDark,
            onRetry: () =>
                context.read<UserAnalysisCubit>().loadMoreHistory(),
          ),

        // ── Load-more row ───────────────────────────────────────────────────
        if (state.hasMoreHistory || state.isHistoryLoading)
          LoadMoreRow(
           isLoading: state.isHistoryLoading,
            isDark: isDark,
            onTap: () => context.read<UserAnalysisCubit>().loadMoreHistory(),
          ),

        const SizedBox(height: 8),
      ],
    );
  }
}