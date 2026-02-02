import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_state.dart';
import 'package:mobile_app/features/verification/presentation/widgets/action_button.dart';
import 'package:mobile_app/features/verification/presentation/widgets/capture_overlay.dart';
import 'package:mobile_app/features/verification/presentation/widgets/circular_camera_frame.dart';
import 'package:mobile_app/features/verification/presentation/widgets/insrtuction_text.dart';
import 'package:mobile_app/features/verification/presentation/widgets/processing_overlay.dart';

class CameraPreviewWidget extends StatelessWidget {
  final VerificationState state;

  const CameraPreviewWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularCameraFrame(controller: state.controller!),
                if (state.isprocessing) const ProcessingOverlay(),
                if (state.hascaptured && !state.isprocessing)
                  const CapturedOverlay(),
              ],
            ),
          ),
        ),
        if (!state.hascaptured && !state.isprocessing)
          const InstructionText(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
          child: ActionButtons(state: state),
        ),
      ],
    );
  }
}