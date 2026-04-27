// core/routing/app_route.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/dependency_injection/init_auth.dart';
import 'package:mobile_app/core/dependency_injection/init_auth_student.dart';
import 'package:mobile_app/core/dependency_injection/init_current_user_di.dart';
import 'package:mobile_app/core/dependency_injection/init_user_attendace.dart';
import 'package:mobile_app/core/dependency_injection/init_verify_get_it.dart';
import 'package:mobile_app/core/dependency_injection/privacy_security_di.dart';
import 'package:mobile_app/core/dependency_injection/scan_ocr_di.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/features/attendance/presentation/views/student_dashboard_screen.dart';
import 'package:mobile_app/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:mobile_app/features/auth/presentation/views/verify_reset_password_otp_screen.dart';
import 'package:mobile_app/features/navigation_screen/presentation/student_navigation.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/privacy_and_security.dart';
import 'package:mobile_app/features/session_mangement/presentation/admin_dashboard.dart';
import 'package:mobile_app/features/profile/presentation/views/profile_screen.dart';
import 'package:mobile_app/features/attendance/presentation/views/user_dashboard_screen.dart';
import 'package:mobile_app/features/navigation_screen/presentation/main_navigation_screen.dart';
import 'package:mobile_app/features/auth/presentation/views/register_screen.dart';
import 'package:mobile_app/features/ocr/presentation/scan_id_screen.dart';
import 'package:mobile_app/features/onboarding/start_page.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_cubit.dart';
import 'package:mobile_app/features/student_auth/presentation/views/login_student_screen.dart';
import 'package:mobile_app/features/student_auth/presentation/views/register_student_screen.dart';
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
        initAuth();
        page = const RegisterScreen();
        break;

      case Routes.studentLoginScreen:
        initAuthStudent();
        page = BlocProvider(
          create: (context) => getIt<AuthStudentCubit>(),
          child: const LoginStudentScreen(),
        );
        break;

      case Routes.registerStudentScreen:
        page = BlocProvider(
          create: (context) => getIt<AuthStudentCubit>(),
          child: const RegisterStudentScreen(),
        );
        break;
      case Routes.forgotPasswordScreen:
        page = const ForgotPasswordScreen();
        break;

      case Routes.verifyResetPasswordOtpScreen:
        page = const VerifyResetPasswordOtpScreen();
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
      case Routes.studentDashboardScreen:
        page = const StudentDashboardScreen();
        break;

      case Routes.studentNavigation:
        page = const StudentNavigationScreen();
        break;

      case Routes.privacyAndSecurityScreen:
        privacySecurityDi();
        page = const PrivacySecurityScreen();
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
