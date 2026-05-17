
import 'package:flutter/widgets.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/user_analysis/domain/entities/status_config.dart';

class StatusBadge extends StatelessWidget {
  final AttendanceStatus status;
  final bool isDark;

  const StatusBadge({required this.status, required this.isDark, super.key});

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

  StatusConfig _resolveConfig() {
    switch (status) {
      case AttendanceStatus.present:
        return isDark
            ? const StatusConfig(
                bg: AppColors.statusGreenBackgroundDarkColor,
                text: AppColors.statusGreenTextDarkColor_v2,
                label: 'Present',
              )
            : const StatusConfig(
                bg: AppColors.statusGreenBackgroundColor,
                text: AppColors.statusGreenTextColor,
                label: 'Present',
              );

      case AttendanceStatus.late:
        return isDark
            ? const StatusConfig(
                bg: Color(0xFF3A2A00),
                text: Color(0xFFFFCC80),
                label: 'Late',
              )
            : const StatusConfig(
                bg: Color(0xFFFFF3E0),
                text: Color(0xFFE65100),
                label: 'Late',
              );

      case AttendanceStatus.absent:
        return isDark
            ? const StatusConfig(
                bg: Color(0xFF3A1A1A),
                text: Color(0xFFEF9A9A),
                label: 'Absent',
              )
            : const StatusConfig(
                bg: Color(0xFFFFEBEE),
                text: Color(0xFFC62828),
                label: 'Absent',
              );
    }
  }
}

