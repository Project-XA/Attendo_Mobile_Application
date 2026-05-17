import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/stats_card.dart';

class StatCardsRow extends StatelessWidget {
  final AttendanceStats stats;

  const StatCardsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final missed = stats.totalSessions - stats.attendedSessions;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Total',
            value: stats.totalSessions.toString(),
            icon: Icons.calendar_month_outlined,
            color: colorScheme.primary,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: StatCard(
            label: 'Attended',
            value: stats.attendedSessions.toString(),
            icon: Icons.check_circle_outline,
            color: AppColors.buttonGreenColor,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: StatCard(
            label: 'Missed',
            value: missed.toString(),
            icon: Icons.cancel_outlined,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}