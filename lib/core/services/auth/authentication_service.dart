import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/*
this service is responsible for handling all authentication related logic, including biometric and pin authentication.
It provides a unified interface for the app to authenticate users using different strategies.
*/


abstract class IBiometricService {
  Future<bool> hasFaceId();
  Future<bool> authenticateWithFaceId();
  Future<bool> hasFingerprint();
  Future<bool> authenticateWithFingerprint();
}

abstract class IPinService {
  String hashPin(String pin);
  bool verifyPin(String pin, String hashed);
}


class AuthenticationService implements IBiometricService, IPinService   {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canUseBiometric() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      final availableBiometrics = await _auth.getAvailableBiometrics();

      return (canCheck || isSupported) && availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasFaceId() async {
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  @override
  Future<bool> hasFingerprint() async {
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong); 
  }

  @override
  Future<bool> authenticateWithFaceId() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate with Face ID to check in',
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithFingerprint() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate with Fingerprint to check in',
      );
    } catch (e) {
      return false;
    }
  }

  @override
  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  bool verifyPin(String enteredPin, String storedHashedPin) {
    final hashedEntered = hashPin(enteredPin);
    return hashedEntered == storedHashedPin;
  }
}
