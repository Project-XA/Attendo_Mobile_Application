import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/feature/verification/company_info_signup.dart';

class CustomBioScreen extends StatefulWidget {
  const CustomBioScreen({super.key});

  @override
  State<CustomBioScreen> createState() => _CustomBioScreenState();
}

class _CustomBioScreenState extends State<CustomBioScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _startAuth() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        biometricOnly: true,
      );

      if (didAuthenticate) {
        Fluttertoast.showToast(
          msg: "Authenticated Successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.of(
          // ignore: use_build_context_synchronously
          context,
        ).push(MaterialPageRoute(builder: (context) => CompanyInfoSignup()));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Authentication Failed",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E0E0F),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fingerprint Animation
            SizedBox(
              height: 220,
              child: Lottie.asset(
                "assets/animations/fingerprint.json",
                repeat: true,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Biometric Verification",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Place your finger on the sensor\nor use Face ID to continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            // Scan Button
            GestureDetector(
              onTap: _startAuth,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.fingerprint, size: 90, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Tap to Scan",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
