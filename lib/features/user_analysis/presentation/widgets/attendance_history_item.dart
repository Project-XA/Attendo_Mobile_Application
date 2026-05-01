import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/theme_cubit.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';

/// A single card showing one [AttendanceHistory] record.
/// Fully theme-aware via [ThemeCubit] — uses [AppColors] only.
class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceHistory record;

  const AttendanceHistoryItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    final cardBg = isDark
        ? AppColors.mainSurfaceDarkColor
        : AppColors.mainBackgroundWhiteColor;

    final borderColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.subTextGreyColor.withOpacity(0.2);

    final titleColor = isDark
        ? AppColors.mainTextDarkColor
        : AppColors.mainTextBlackColor;

    final subtitleColor = isDark
        ? AppColors.subTextDarkColor
        : AppColors.subTextGreyColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status indicator pill ─────────────────────────────────────
            _StatusBadge(status: record.status, isDark: isDark),
            const SizedBox(width: 14),

            // ── Info column ───────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.sessionName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpace(4),
                  _IconRow(
                    icon: Icons.location_on_outlined,
                    label: record.location,
                    color: subtitleColor,
                  ),
                  verticalSpace(3),
                  _IconRow(
                    icon: Icons.access_time_rounded,
                    label: _formatDateTime(record.checkInTime),
                    color: subtitleColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final date = DateFormat('dd MMM yyyy').format(dt);
    final time = DateFormat('hh:mm a').format(dt);
    return '$date · $time';
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final AttendanceStatus status;
  final bool isDark;

  const _StatusBadge({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final config = _resolveConfig();

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: config.text,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  _StatusConfig _resolveConfig() {
    switch (status) {
      case AttendanceStatus.present:
        return isDark
            ? const _StatusConfig(
                bg: AppColors.statusGreenBackgroundDarkColor,
                text: AppColors.statusGreenTextDarkColor_v2,
                label: 'Present',
              )
            : const _StatusConfig(
                bg: AppColors.statusGreenBackgroundColor,
                text: AppColors.statusGreenTextColor,
                label: 'Present',
              );

      case AttendanceStatus.late:
        return isDark
            ? const _StatusConfig(
                bg: Color(0xFF3A2A00),
                text: Color(0xFFFFCC80),
                label: 'Late',
              )
            : const _StatusConfig(
                bg: Color(0xFFFFF3E0),
                text: Color(0xFFE65100),
                label: 'Late',
              );

      case AttendanceStatus.absent:
        return isDark
            ? const _StatusConfig(
                bg: Color(0xFF3A1A1A),
                text: Color(0xFFEF9A9A),
                label: 'Absent',
              )
            : const _StatusConfig(
                bg: Color(0xFFFFEBEE),
                text: Color(0xFFC62828),
                label: 'Absent',
              );
    }
  }
}

class _StatusConfig {
  final Color bg;
  final Color text;
  final String label;
  const _StatusConfig({
    required this.bg,
    required this.text,
    required this.label,
  });
}

// ─── Icon + label row ─────────────────────────────────────────────────────────

class _IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _IconRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
