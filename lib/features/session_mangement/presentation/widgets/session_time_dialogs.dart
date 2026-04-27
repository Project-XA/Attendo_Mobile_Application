import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/toast_service.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

void showPastTimeConfirmationDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
}) {
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
          SizedBox(width: 8.w),
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
            onConfirm();
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

void showFutureTimeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      title: Row(
        children: [
          Icon(Icons.schedule, color: Colors.blue, size: 24.sp),
          SizedBox(width: 8.w),
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
          child: Text(
            'common.ok'.tr(),
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ],
    ),
  );
}