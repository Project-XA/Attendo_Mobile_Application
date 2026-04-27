import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/dependency_injection/init_current_student.dart';
import 'package:mobile_app/core/dependency_injection/init_user_attendace.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/attendance/presentation/views/student_dashboard_screen.dart';
import 'package:mobile_app/features/profile/presentation/views/student_profile_screen.dart';

class StudentNavigationScreen extends StatefulWidget {
  const StudentNavigationScreen({super.key});

  @override
  State<StudentNavigationScreen> createState() =>
      _StudentNavigationScreenState();
}

class _StudentNavigationScreenState extends State<StudentNavigationScreen> {
  bool _diInitialized = false;

  void _initDI() {
    if (_diInitialized) return;
    initCurrentStudentDi();
    initUserAttendace();
    _diInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CurrentStudentCubit>()..loadStudent(),
      child: BlocBuilder<CurrentStudentCubit, CurrentStudentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    verticalSpace(16),
                    Text(
                      'common.error_occurred'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    verticalSpace(8),
                    Text(state.error!),
                    verticalSpace(16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CurrentStudentCubit>().loadStudent(),
                      child: Text('common.try_again'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.student == null) {
            return Scaffold(
              body: Center(child: Text('common.no_user_found'.tr())),
            );
          }

          _initDI();

          return const _StudentNavigationContent();
        },
      ),
    );
  }
}

class _StudentNavigationContent extends StatefulWidget {
  const _StudentNavigationContent();

  @override
  State<_StudentNavigationContent> createState() =>
      _StudentNavigationContentState();
}

class _StudentNavigationContentState extends State<_StudentNavigationContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const screens = <Widget>[StudentDashboardScreen(), StudentProfileScreen()];

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24.sp),
            activeIcon: Icon(Icons.home, size: 26.sp),
            label: 'navigation.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24.sp),
            activeIcon: Icon(Icons.person, size: 26.sp),
            label: 'navigation.profile'.tr(),
          ),
        ],
      ),
    );
  }
}
