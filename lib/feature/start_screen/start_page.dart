import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/core/services/local_auth_service.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/feature/start_screen/widgets/auto_text_slider.dart';
import 'package:mobile_app/feature/verification/company_info_signup.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localAuthService = LocalAuthService();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          bool isLargeScreen = constraints.maxWidth > 900;

          double logoSize = isLargeScreen
              ? 450
              : isTablet
              ? 400
              : 300;

          double textFont = isTablet ? 18 : 15;

          log(logoSize);
          log(textFont);

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 48.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),

                  Center(
                    child: SizedBox(
                      height: logoSize,

                      width: logoSize,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AutoTextSlider(),
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Team and Project management with\nsolution providing App",
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.6),
                        fontSize: textFont,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 70 : 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool canAuth = await localAuthService.canAuthenticate();

                        if (!canAuth) {
                          Fluttertoast.showToast(
                            msg: "Biometric authentication is not available",
                          );
                          return;
                        }

                        final biometrics = await localAuthService
                            .getAvailableBiometrics();
                        if (biometrics.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "No biometric sensors found",
                          );
                          return;
                        }

                        bool isVerified = await localAuthService
                            .authenticateUser();

                        if (isVerified) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompanyInfoSignup(),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Authentication Failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.black.withOpacity(0.1),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
