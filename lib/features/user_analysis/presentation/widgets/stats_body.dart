
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_cubit.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/attendance_history_section.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/attendance_presentage_card.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/cache_badge.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/status_cards_row.dart';

class StatsBody extends StatefulWidget {
  final dynamic stats;
  final bool isStale;

  const StatsBody({super.key, required this.stats, required this.isStale});

  @override
  State<StatsBody> createState() => _StatsBodyState();
}

class _StatsBodyState extends State<StatsBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserAnalysisCubit>().loadHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<UserAnalysisCubit>().refresh(),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (widget.isStale) const CacheBadge(),
          AttendancePercentageCard(stats: widget.stats),
          verticalSpace(16),
          StatCardsRow(stats: widget.stats),
          verticalSpace(28),

          const AttendanceHistorySection(),
        ],
      ),
    );
  }
}
