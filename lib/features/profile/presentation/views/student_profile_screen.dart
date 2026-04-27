import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_drawer.dart';
import 'package:mobile_app/features/profile/presentation/widgets/student_profile_screen_body.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final _drawerController = AdvancedDrawerController();

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: getIt<CurrentStudentCubit>()..loadStudent(),
      child: AdvancedDrawer(
        controller: _drawerController,
        backdropColor: theme.scaffoldBackgroundColor,
        rtlOpening: false,
        openRatio: 0.75,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        drawer: ProfileDrawer(drawerController: _drawerController),
        child: StudentProfileScreenBody(drawerController: _drawerController),
      ),
    );
  }
}