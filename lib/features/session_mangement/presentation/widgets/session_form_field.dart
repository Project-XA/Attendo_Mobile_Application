import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/hall_section_dropdown.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/session_duration_field.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/session_name_field.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/session_redius_field.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/session_timer_picker.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/wifi_dropdown.dart';

class SessionFormFields extends StatelessWidget {
  final TextEditingController sessionNameController;
  final TextEditingController durationController;
  final TextEditingController allowedRadiusController;
  final TimeOfDay? initialTime;
  final String? initialWifiOption;
  final Function(TimeOfDay) onTimeSelected;
  final Function(String?) onWifiOptionChanged;
  final Function(int?, String?)? onHallSelected;
  final VoidCallback? onRefreshHalls;
  final int? selectedHallId;
  final bool isUniversity;

  const SessionFormFields({
    super.key,
    required this.sessionNameController,
    required this.durationController,
    required this.allowedRadiusController,
    this.initialTime,
    this.initialWifiOption,
    required this.onTimeSelected,
    required this.onWifiOptionChanged,
    this.onHallSelected,
    this.selectedHallId,
    this.onRefreshHalls,
    required this.isUniversity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SessionNameField(controller: sessionNameController),
        verticalSpace(15.h),
        HallSectionDropdown(
          isUniversity: isUniversity,
          selectedId: selectedHallId,
          onSelected: onHallSelected,
          onRefresh: onRefreshHalls,
        ),
        verticalSpace(15.h),
        WifiDropdown(
          initialValue: initialWifiOption,
          onChanged: onWifiOptionChanged,
        ),
        verticalSpace(15.h),
        SessionTimePicker(
          initialTime: initialTime,
          onTimeSelected: onTimeSelected,
        ),
        verticalSpace(15.h),
        SessionDurationField(controller: durationController),
        verticalSpace(15.h),
        SessionRadiusField(controller: allowedRadiusController),
      ],
    );
  }
}