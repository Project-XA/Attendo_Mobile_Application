import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/services/UI/toast_service.dart';
import 'package:mobile_app/core/services/location/location_helper.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/session_form_field.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateSessionForm extends StatefulWidget {
  const CreateSessionForm({super.key});

  @override
  State<CreateSessionForm> createState() => _CreateSessionFormState();
}

class _CreateSessionFormState extends State<CreateSessionForm> {
  final _formKey = GlobalKey<FormState>();
  final _sessionNameController = TextEditingController();
  final _durationController = TextEditingController(text: '60');
  final _allowedRadiusController = TextEditingController(text: '50');

  TimeOfDay? _selectedTime;
  String? _selectedWifiOption = 'WiFi';
  int? _selectedHallId;
  String? _selectedHallName;

  @override
  void dispose() {
    _sessionNameController.dispose();
    _durationController.dispose();
    _allowedRadiusController.dispose();
    super.dispose();
  }

  void _handleStartSession() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTime == null) {
      showToast(
        message: 'sessions.select_time_toast'.tr(),
        type: ToastType.error,
      );
      return;
    }

    final timeValidation = _validateSelectedTime(_selectedTime!);
    if (timeValidation != null) {
      if (timeValidation == TimeValidation.pastTime) {
        _showPastTimeConfirmationDialog();
        return;
      } else if (timeValidation == TimeValidation.futureTime) {
        _showFutureTimeDialog();
        return;
      }
    }

    final locationStatus = await LocationHelper.check();

    if (locationStatus == LocationStatus.serviceDisabled) {
      _showLocationSettingsDialog();
      return;
    }

    if (locationStatus == LocationStatus.deniedForever) {
      _showAppSettingsDialog();
      return;
    }

    _startSession();
  }

  TimeValidation? _validateSelectedTime(TimeOfDay selectedTime) {
    final now = DateTime.now();
    final sessionStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final difference = sessionStartTime.difference(now);

    if (difference.isNegative && difference.inMinutes.abs() > 5) {
      return TimeValidation.pastTime;
    }

    if (difference.inMinutes > 10) {
      return TimeValidation.futureTime;
    }

    return null;
  }

  void _showPastTimeConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 24.sp,
            ),
            horizontalSpace(8.w),
            Flexible(
              child: Text(
                'sessions.past_time_title'.tr(),
                style: AppTextStyle.font18BlackSemiBold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'sessions.past_time_body'.tr(),
            style: AppTextStyle.font14GreyRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'common.cancel'.tr(),
              style: AppTextStyle.font14GreyRegular,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              _startSession();
            },
            child: Text(
              'common.continue'.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showFutureTimeDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Row(
          children: [
            Icon(Icons.schedule, color: Colors.blue, size: 24.sp),
            horizontalSpace(8.w),
            Flexible(
              child: Text(
                'sessions.future_time_title'.tr(),
                style: AppTextStyle.font18BlackSemiBold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'sessions.future_time_body'.tr(),
            style: AppTextStyle.font14GreyRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'common.cancel'.tr(),
              style: AppTextStyle.font14GreyRegular,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              showToast(
                message: 'sessions.future_not_supported_toast'.tr(),
                type: ToastType.info,
              );
            },
            child: Text('common.ok'.tr(), style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  void _startSession() {
    context.read<SessionManagementCubit>().createAndStartSession(
      name: _sessionNameController.text.trim(),
      location: _selectedHallName ?? '',
      connectionMethod: _selectedWifiOption ?? 'WiFi',
      startTime: _selectedTime!,
      durationMinutes: int.parse(_durationController.text.trim()),
      allowedRadius: double.parse(_allowedRadiusController.text.trim()),
      hallId: _selectedHallId,
    );
  }

  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Flexible(
          child: Text(
            'sessions.location_services_disabled_title'.tr(),
            style: AppTextStyle.font18BlackSemiBold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'sessions.location_services_disabled_body'.tr(),
            style: AppTextStyle.font14GreyRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'common.cancel'.tr(),
              style: AppTextStyle.font14GreyRegular,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: Text(
              'common.open_settings'.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Flexible(
          child: Text(
            'sessions.location_permission_title'.tr(),
            style: AppTextStyle.font18BlackSemiBold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'sessions.location_permission_body'.tr(),
            style: AppTextStyle.font14GreyRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'common.cancel'.tr(),
              style: AppTextStyle.font14GreyRegular,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: Text(
              'common.open_settings'.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkErrorBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade300, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sessions.no_internet_title'.tr(),
                  style: AppTextStyle.font16Red900Bold,
                ),
                verticalSpace(4.h),
                Text(
                  'sessions.no_internet_body'.tr(),
                  style: AppTextStyle.font13Red700Medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionManagementCubit, SessionManagementState>(
      listener: (context, state) {
        if (state is SessionError) {
          if (!state.error.isNetworkError) {
            showToast(message: state.error.message, type: ToastType.error);
          }
        }
      },
      builder: (context, state) {
        if (state is SessionState && state.isActive) {
          return const SizedBox.shrink();
        }

        final isLoading = state is SessionState && state.isLoading;
        final showNetworkError = state is SessionError && state.isNetworkError;

        return Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(20.h),

                if (showNetworkError) _buildNetworkErrorBanner(),

                SessionFormFields(
                  sessionNameController: _sessionNameController,
                  durationController: _durationController,
                  allowedRadiusController: _allowedRadiusController,
                  initialTime: _selectedTime,
                  initialWifiOption: _selectedWifiOption,
                  selectedHallId: _selectedHallId,
                  onTimeSelected: (time) {
                    setState(() => _selectedTime = time);
                  },
                  onWifiOptionChanged: (option) {
                    setState(() => _selectedWifiOption = option);
                  },
                  onHallSelected: (hallId, hallName) {
                    setState(() {
                      _selectedHallId = hallId;
                      _selectedHallName = hallName;
                    });
                  },
                  onRefreshHalls: () =>
                      context.read<SessionManagementCubit>().loadHalls(),
                ),

                verticalSpace(25.h),

                CustomAppButton(
                  onPressed: isLoading ? null : _handleStartSession,
                  backgroundColor: isLoading
                      ? Colors.grey
                      : Theme.of(context).colorScheme.onSurface,
                  borderRadius: 20.r,
                  width: double.infinity,
                  height: 45.h,
                  child: isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.surface,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'sessions.start_session'.tr(),
                          style: AppTextStyle.font16WhiteMedium,
                        ),
                ),

                verticalSpace(20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum TimeValidation { pastTime, futureTime }