import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_state.dart';
import 'package:mobile_app/features/verification/presentation/widgets/verfication_body.dart';
import 'package:mobile_app/features/verification/presentation/widgets/verification_header.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VerificationCubit>().opencamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      body: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state.isVerificationComplete && !state.hasError) {
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.pushReplacmentNamed(Routes.registerScreen);
              }
            });
          }
        },
        child: BlocBuilder<VerificationCubit, VerificationState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  const VerificationHeader(),
                  Expanded(child: VerificationBody(state: state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
