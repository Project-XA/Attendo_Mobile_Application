import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthenticationService {
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

  Future<bool> hasFaceId() async {
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  Future<bool> hasFingerprint() async {
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong); 
  }

  Future<bool> authenticateWithFaceId() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate with Face ID to check in',
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithFingerprint() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate with Fingerprint to check in',
      );
    } catch (e) {
      return false;
    }
  }

  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  bool verifyPin(String enteredPin, String storedHashedPin) {
    final hashedEntered = hashPin(enteredPin);
    return hashedEntered == storedHashedPin;
  }
}
