import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_profile.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    initProfile();
    return BlocProvider(
      create: (context) => getIt<UserProfileCubit>()..loadUser(),
      child: const ProfileScreenBody(),
    );
  }
}
