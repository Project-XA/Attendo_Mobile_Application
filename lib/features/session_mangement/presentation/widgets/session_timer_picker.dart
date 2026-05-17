import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class SessionTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const SessionTimePicker({
    super.key,
    this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<SessionTimePicker> createState() => _SessionTimePickerState();
}

class _SessionTimePickerState extends State<SessionTimePicker> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('sessions.session_start_time_section'.tr(),
            style: AppTextStyle.font12GreyBold),
        verticalSpace(8.h),
        InkWell(
          onTap: _pickTime,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime == null
                      ? 'sessions.time_placeholder'.tr()
                      : _selectedTime!.format(context),
                  style: AppTextStyle.font14GreyMedium.copyWith(
                    color: _selectedTime == null
                        ? colorScheme.outline
                        : colorScheme.onSurface,
                  ),
                ),
                Icon(Icons.access_time,
                    color: colorScheme.outline, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}