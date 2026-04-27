import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:permission_handler/permission_handler.dart';

void showLocationSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
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
          onPressed: () async {
            Navigator.pop(dialogContext);
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

void showAppSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
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
          onPressed: () async {
            Navigator.pop(dialogContext);
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