import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';

class SessionFormFields extends StatefulWidget {
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
  });

  @override
  State<SessionFormFields> createState() => _SessionFormFieldsState();
}

class _SessionFormFieldsState extends State<SessionFormFields> {
  static const List<String> _wifiOptions = ['WiFi'];

  late TimeOfDay? _selectedTime;
  late String? _selectedWifiOption;
  int? _selectedHallId;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _selectedWifiOption = widget.initialWifiOption ?? 'WiFi';
    _selectedHallId = widget.selectedHallId;
  }

  @override
  void didUpdateWidget(SessionFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedHallId != oldWidget.selectedHallId) {
      setState(() {
        _selectedHallId = widget.selectedHallId;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSessionNameField(),
        verticalSpace(15.h),

        _buildHallDropdown(),
        verticalSpace(15.h),

        _buildWifiDropdown(),
        verticalSpace(15.h),

        _buildTimePicker(context),
        verticalSpace(15.h),

        _buildDurationField(),
        verticalSpace(15.h),

        _buildAllowedRadiusField(),
      ],
    );
  }

  Widget _buildSessionNameField() {
    return AppTextFormField(
      borderRadius: 20.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      focusedBorderColor: Theme.of(context).colorScheme.onSurface,
      enabledBorderColor: Theme.of(context).colorScheme.outline,
      controller: widget.sessionNameController,
      hintText: 'sessions.hint_session_name'.tr(),
      labelStyle: AppTextStyle.font14GreyMedium,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'sessions.val_session_name_required'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildHallDropdown() {
    final state = context.watch<SessionManagementCubit>().state;

    final bool isLoadingHalls =
        state is SessionManagementIdle && state.isLoadingHalls;
    final bool hasNetworkError = state is SessionError;
    final List<HallInfo>? halls =
        state is SessionManagementIdle ? state.halls : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sessions.org_hall_section'.tr(),
          style: AppTextStyle.font12GreyBold,
        ),
        verticalSpace(8.h),

        if (isLoadingHalls)
          _buildHallLoadingState()
        else if (hasNetworkError || halls == null)
          _buildHallErrorState()
        else
          _buildHallDropdownField(halls),
      ],
    );
  }

  Widget _buildHallLoadingState() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'sessions.loading_halls'.tr(),
            style: AppTextStyle.font13Grey600Medium,
          ),
        ],
      ),
    );
  }

  Widget _buildHallErrorState() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.red.shade50,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'sessions.failed_load_halls'.tr(),
              style: AppTextStyle.font13Red700Medium,
            ),
          ),
          IconButton(
            onPressed: widget.onRefreshHalls,
            icon: Icon(Icons.refresh, color: Colors.red, size: 20.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'common.retry'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildHallDropdownField(List<HallInfo> halls) {
    if (halls.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade300),
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.orange.shade50,
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'sessions.no_halls'.tr(),
                style: AppTextStyle.font13Orange700Medium,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.r),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedHallId,
          isExpanded: true,
          hint: Text('sessions.select_hall_hint'.tr()),
          icon: const Icon(Icons.keyboard_arrow_down),
          style: AppTextStyle.font14BlackMedium,
          items: halls.map((HallInfo hall) {
            return DropdownMenuItem<int>(
              value: hall.id,
              child: Text(hall.hallName),
            );
          }).toList(),
          focusColor: Theme.of(context).colorScheme.surface,
          dropdownColor: Theme.of(context).colorScheme.surface,
          onChanged: (hallId) {
            if (hallId != null) {
              setState(() => _selectedHallId = hallId);
              final hallName =
                  halls.firstWhere((h) => h.id == hallId).hallName;
              widget.onHallSelected?.call(hallId, hallName);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWifiDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sessions.connection_method_section'.tr(),
          style: AppTextStyle.font12GreyBold,
        ),
        verticalSpace(8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWifiOption,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: AppTextStyle.font14BlackMedium,
              items: _wifiOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value == 'WiFi'
                        ? 'sessions.connection_wifi'.tr()
                        : value,
                  ),
                );
              }).toList(),
              dropdownColor: Theme.of(context).colorScheme.surface,
              onChanged: (option) {
                if (option != null && option != _selectedWifiOption) {
                  setState(() => _selectedWifiOption = option);
                  widget.onWifiOptionChanged(option);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sessions.session_start_time_section'.tr(),
          style: AppTextStyle.font12GreyBold,
        ),
        verticalSpace(8.h),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
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
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSurface
                  ),
                ),
                Icon(Icons.access_time, color: Colors.grey, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sessions.duration_section'.tr(),
          style: AppTextStyle.font12GreyBold,
        ),
        verticalSpace(8.h),
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          focusedBorderColor: Theme.of(context).colorScheme.onSurface,
          enabledBorderColor: Colors.grey,
          controller: widget.durationController,
          hintText: "60",
          keyboardType: TextInputType.number,
          labelStyle: AppTextStyle.font14GreyMedium,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'sessions.val_duration_required'.tr();
            }
            final duration = int.tryParse(value);
            if (duration == null || duration <= 0) {
              return 'sessions.val_duration_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAllowedRadiusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sessions.radius_section'.tr(),
          style: AppTextStyle.font12GreyBold,
        ),
        verticalSpace(8.h),
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          focusedBorderColor: Theme.of(context).colorScheme.onSurface,
          enabledBorderColor: Colors.grey,
          controller: widget.allowedRadiusController,
          hintText: "50",
          keyboardType: TextInputType.number,
          labelStyle: AppTextStyle.font14GreyMedium,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'sessions.val_radius_required'.tr();
            }
            final radius = double.tryParse(value);
            if (radius == null || radius <= 0) {
              return 'sessions.val_radius_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}