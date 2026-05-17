import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/theme_cubit.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/icon_row.dart';
import 'package:mobile_app/features/user_analysis/presentation/widgets/status_badge.dart';

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
            StatusBadge(status: record.status, isDark: isDark),
            const SizedBox(width: 14),

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
                  IconRow(
                    icon: Icons.location_on_outlined,
                    label: record.location,
                    color: subtitleColor,
                  ),
                  verticalSpace(3),
                  IconRow(
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
