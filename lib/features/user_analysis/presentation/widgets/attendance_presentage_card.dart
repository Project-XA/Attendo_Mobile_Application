import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

class AttendancePercentageCard extends StatelessWidget {
  final AttendanceStats stats;

  const AttendancePercentageCard({super.key, required this.stats});

  Color _statusColor(double pct) {
    if (pct >= 90) return AppColors.buttonGreenColor;
    if (pct >= 75) return Colors.amber;
    if (pct >= 60) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _statusColor(stats.attendancePercentage);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${stats.attendancePercentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            verticalSpace(4),
            Text(
              'Attendance Rate',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
            verticalSpace(16),
            LinearProgressIndicator(
              value: stats.attendancePercentage / 100,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
