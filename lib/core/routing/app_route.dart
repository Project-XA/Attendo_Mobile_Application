// core/routing/app_route.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_current_user_di.dart';
import 'package:mobile_app/core/DI/init_user_attendace.dart';
import 'package:mobile_app/core/DI/init_verify_get_it.dart';
import 'package:mobile_app/core/DI/register_get_it.dart';
import 'package:mobile_app/core/DI/scan_ocr_di.dart';
import 'package:mobile_app/core/DI/forgot_password_get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/features/auth/presentation/forgot_password_screen.dart';
import 'package:mobile_app/features/auth/presentation/verify_reset_password_otp_screen.dart';
import 'package:mobile_app/features/session_mangement/presentation/admin_dashboard.dart';
import 'package:mobile_app/features/profile/presentation/profile_screen.dart';
import 'package:mobile_app/features/attendance/presentation/user_dashboard_screen.dart';
import 'package:mobile_app/features/navigation_screen/presentation/main_navigation_screen.dart';
import 'package:mobile_app/features/auth/presentation/register_screen.dart';
import 'package:mobile_app/features/ocr/presentation/scan_id_screen.dart';
import 'package:mobile_app/features/onboarding/start_page.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/features/verification/presentation/verification_screen.dart';

class AppRoute {
  Route generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case Routes.startPage:
        page = const StartPage();
        break;

      case Routes.scanIdScreen:
        setupScanOcrFeature();
        page = const ScanIdScreen();
        break;

      case Routes.registerScreen:
        initRegister();
        page = const RegisterScreen();
        break;

      case Routes.forgotPasswordScreen:
        initForgotPassword();
        page = const ForgotPasswordScreen();
        break;

      case Routes.verifyResetPasswordOtpScreen:
        initForgotPassword();
        final email = (settings.arguments is String) ? settings.arguments as String : '';
        page = VerifyResetPasswordOtpScreen(email: email);
        break;

      case Routes.mainNavigation:
        initCurrentUserDi();
        page = const MainNavigationScreen();
        break;

      case Routes.verficationScreen:
        initVerifyScreen();
        page = BlocProvider(
          create: (context) => VerificationCubit(getIt(), getIt(), getIt()),
          child: const VerificationScreen(),
        );

        break;
      case Routes.homePage:
        initUserAttendace();
        page = const UserDashboardScreen();
        break;

      case Routes.adminDashboard:
        page = const AdminDashboard();
        break;

      case Routes.profileScreen:
        page = const ProfileScreen();
        break;

      default:
        page = const Scaffold(body: Center(child: Text('Route not found')));
    }

    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
