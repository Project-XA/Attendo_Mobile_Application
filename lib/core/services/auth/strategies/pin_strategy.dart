import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/services/auth/authentication_service.dart';
import 'package:mobile_app/core/services/auth/strategies/auth_strategy.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/pin_setup_screen.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/pin_verify_screen.dart';

class PinStrategy implements AuthStrategy {
  final IPinService _iPinService;

  PinStrategy(this._iPinService);

  @override
  Future<bool> tryAuthenticate(BuildContext context) async {
    final currentUserCubit = context.read<CurrentUserCubit>();
    final user = currentUserCubit.currentUser;

    if (user == null) {
      _showError(context, 'User not found');
      return false;
    }

    final hasPin = user.pinCode != null && user.pinCode!.isNotEmpty;

    if (hasPin) {
      return await _verifyExistingPin(context, user.pinCode!);
    } else {
      return await _setupNewPin(context, currentUserCubit);
    }
  }

  Future<bool> _setupNewPin(
    BuildContext context,
    CurrentUserCubit currentUserCubit,
  ) async {
    final newPin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog.fullscreen(child: PinSetupScreen()),
    );

    if (newPin == null || newPin.length != 4) return false;

    final hashedPin = _iPinService.hashPin(newPin);

    try {
      await currentUserCubit.updatePinCode(hashedPin);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error saving PIN: $e');
      if (context.mounted) {
        _showError(context, 'Failed to save PIN. Please try again.');
      }
      return false;
    }
  }

  Future<bool> _verifyExistingPin(
    BuildContext context,
    String storedHashedPin, {
    int attemptNumber = 1,
  }) async {
    final enteredPin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog.fullscreen(child: PinVerifyScreen()),
    );

    if (enteredPin == null || enteredPin.length != 4) return false;

    final isCorrect = _iPinService.verifyPin(enteredPin, storedHashedPin);

    if (!isCorrect) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Wrong PIN. ${attemptNumber < 3 ? 'Please try again.' : 'Maximum attempts reached.'}',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        if (attemptNumber < 3) {
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            return await _verifyExistingPin(
              context,
              storedHashedPin,
              attemptNumber: attemptNumber + 1,
            );
          }
        }
      }
      return false;
    }

    return true;
  }

  void _showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
