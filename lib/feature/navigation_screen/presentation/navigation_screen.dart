import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/navigation_get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/feature/navigation_screen/presentation/logic/navigation_cubit.dart';
import 'package:mobile_app/feature/navigation_screen/presentation/logic/navigation_state.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    initNavigation();
    return BlocProvider(
      create: (context) => getIt<NavigationCubit>()..determineNavigation(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<NavigationCubit, NavigationState>(
          listener: (context, state) {
            if (state is NavigationToMainScreen) {
              context.pushReplacmentNamed(
                Routes.mainNavigation,
                arguments: state.role,
              );
            } else if (state is NavigationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  context.pushReplacmentNamed(Routes.scanIdScreen);
                }
              });
            }
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
