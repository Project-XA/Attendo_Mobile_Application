import 'package:flutter/material.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_state.dart';
import 'package:mobile_app/features/verification/presentation/widgets/camera_preview_widget.dart';
import 'package:mobile_app/features/verification/presentation/widgets/error_state_widget.dart';
import 'package:mobile_app/features/verification/presentation/widgets/loading_stat.dart';
import 'package:mobile_app/features/verification/presentation/widgets/permission_denied.dart';
import 'package:mobile_app/features/verification/presentation/widgets/verification_failed_state.dart';
import 'package:mobile_app/features/verification/presentation/widgets/verification_state_success.dart';

class VerificationBody extends StatelessWidget {
  final VerificationState state;

  const VerificationBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isVerificationComplete && !state.isnotVerified) {
      return const VerificationSuccessState();
    }

    if (state.isnotVerified) {
      return const VerificationFailedState();
    }

    if (state.isInitializing) {
      return const LoadingState(message: 'Initializing camera...');
    }

    if (state.hasPermissionDenied) {
      return const PermissionDeniedState();
    }

    if (state.hasError) {
      return ErrorStateWidget(errorMessage: state.errorMessage);
    }

    if (state.isCameraReady && state.controller != null) {
      return CameraPreviewWidget(state: state);
    }

    return const LoadingState(message: 'Initializing camera...');
  }
}