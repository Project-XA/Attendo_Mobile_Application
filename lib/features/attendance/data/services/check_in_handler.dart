import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/services/auth/authentication_manager.dart';
import 'package:mobile_app/core/services/location/location_helper.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckInHandler {
  final AuthenticationManager authManager;

  CheckInHandler({required this.authManager});

  Future<void> handle(BuildContext context, NearbySession session) async {
    final locationStatus = await LocationHelper.check();

    if (locationStatus == LocationStatus.serviceDisabled) {
      if (context.mounted) _showLocationSettingsDialog(context);
      return;
    }

    if (locationStatus == LocationStatus.deniedForever) {
      if (context.mounted) _showAppSettingsDialog(context);
      return;
    }

    if (!context.mounted) return;

    final isAuthenticated = await authManager.authenticate(context);

    if (!isAuthenticated) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication required to check in'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;
    _showLoadingDialog(context);

    final user = context.read<CurrentUserCubit>().currentUser;
    if (user != null) {
      context.read<UserCubit>().checkIn(
        session,
        userId: user.id!,
        userName: user.fullNameEn,
      );
    }

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.backGroundColorWhite,
        ),
      ),
    );
  }

  void _showLocationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backGroundColorWhite,
        title: const Text(
          'Location Services Disabled',
          style: TextStyle(
            color: AppColors.mainTextColorBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Location services are required for check-in. Please enable location services in your device settings.',
          style: TextStyle(color: AppColors.subTextColorGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.subTextColorGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainTextColorBlack,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showAppSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backGroundColorWhite,
        title: const Text(
          'Location Permission Required',
          style: TextStyle(
            color: AppColors.mainTextColorBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Location permission is permanently denied. Please enable it in app settings to check in.',
          style: TextStyle(color: AppColors.subTextColorGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.subTextColorGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainTextColorBlack,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}