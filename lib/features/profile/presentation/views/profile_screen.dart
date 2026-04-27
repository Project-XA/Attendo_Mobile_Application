import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_drawer.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_screen_body.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      value: getIt<CurrentUserCubit>()..loadUser(),
      child: AdvancedDrawer(
        controller: _drawerController,
        backdropColor: theme.scaffoldBackgroundColor,
        rtlOpening: false,
        openRatio: 0.75,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        drawer: ProfileDrawer(drawerController: _drawerController),
        child: ProfileScreenBody(drawerController: _drawerController),
      ),
    );
  }
}