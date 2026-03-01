import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/auth/authentication_service.dart';
import 'package:mobile_app/core/services/auth/strategies/auth_strategy.dart';
import 'package:mobile_app/core/services/auth/strategies/face_id_strategy.dart';
import 'package:mobile_app/core/services/auth/strategies/fingerprint_strategy.dart';
import 'package:mobile_app/core/services/auth/strategies/pin_strategy.dart';

/*
this class is responsible for managing the authentication process. It holds a list of authentication strategies and tries each one in order until one succeeds or all fail.
This allows for a flexible authentication flow that can easily be extended with new strategies in the future.
 */
class AuthenticationManager {
  late final List<AuthStrategy> _strategies;

  AuthenticationManager({
    required IBiometricService biometricService,
    required IPinService pinService,
  }) {
    _strategies = [
      FaceIdStrategy(biometricService),
      FingerprintStrategy(biometricService),
      PinStrategy(pinService),
    ];
  }
  Future<bool> authenticate(BuildContext context) async {
    try {
      for (final strategy in _strategies) {
        if (await strategy.tryAuthenticate(context)) return true;
      }
      return false;
    } catch (e) {
      debugPrint('Authentication error: $e');
      return false;
    }
  }
}
