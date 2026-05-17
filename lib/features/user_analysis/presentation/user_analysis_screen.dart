import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_cubit.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_state.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/error_body.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/stats_body.dart';

class UserAnalysisScreen extends StatelessWidget {
  const UserAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UserAnalysisView();
  }
}

class _UserAnalysisView extends StatefulWidget {
  const _UserAnalysisView();

  @override
  State<_UserAnalysisView> createState() => _UserAnalysisViewState();
}

class _UserAnalysisViewState extends State<_UserAnalysisView> {
  @override
  void initState() {
    super.initState();
    context.read<UserAnalysisCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Analysis',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeightHelper.semiBold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<UserAnalysisCubit, UserAnalysisState>(
        builder: (context, state) {
          return switch (state) {
            UserAnalysisInitial() => const SizedBox.shrink(),
            UserAnalysisLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            UserAnalysisCacheLoaded(:final stats) => StatsBody(
              stats: stats,
              isStale: true,
            ),
            UserAnalysisLoaded(:final stats) => StatsBody(
              stats: stats,
              isStale: false,
            ),
            UserAnalysisError(:final message) => ErrorBody(
              message: message,
              onRetry: () => context.read<UserAnalysisCubit>().refresh(),
            ),
          };
        },
      ),
    );
  }
}

// ─── Stats Body ───────────────────────────────────────────────────────────────
