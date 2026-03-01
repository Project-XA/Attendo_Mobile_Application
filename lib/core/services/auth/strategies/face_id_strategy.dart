import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/auth/authentication_service.dart';
import 'package:mobile_app/core/services/auth/strategies/auth_strategy.dart';

class FaceIdStrategy implements AuthStrategy {
  final IBiometricService _biometricService;

  FaceIdStrategy(this._biometricService);

  @override
  Future<bool> tryAuthenticate(BuildContext context) async {
    final hasFace = await _biometricService.hasFaceId();
    if (!hasFace) return false;
    return await _biometricService.authenticateWithFaceId();
  }
}
