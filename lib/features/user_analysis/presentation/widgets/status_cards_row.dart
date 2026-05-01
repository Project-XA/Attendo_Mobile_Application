import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

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
          child: _StatCard(
            label: 'Total',
            value: stats.totalSessions.toString(),
            icon: Icons.calendar_month_outlined,
            color: colorScheme.primary,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: _StatCard(
            label: 'Attended',
            value: stats.attendedSessions.toString(),
            icon: Icons.check_circle_outline,
            color: AppColors.buttonGreenColor,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: _StatCard(
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

// ─── Private helper ───────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            verticalSpace(8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            verticalSpace(2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
