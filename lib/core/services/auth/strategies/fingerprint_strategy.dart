import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/auth/authentication_service.dart';
import 'package:mobile_app/core/services/auth/strategies/auth_strategy.dart';

class FingerprintStrategy implements AuthStrategy {
  final IBiometricService _biometricService;

  FingerprintStrategy(this._biometricService);

  @override
  Future<bool> tryAuthenticate(BuildContext context) async {
    final hasFingerprint = await _biometricService.hasFingerprint();
    if (!hasFingerprint) return false;
    return await _biometricService.authenticateWithFingerprint();
  }
}