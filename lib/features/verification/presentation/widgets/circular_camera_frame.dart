import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularCameraFrame extends StatelessWidget {
  final CameraController controller;

  const CircularCameraFrame({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 320.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 4),
      ),
      child: ClipOval(child: CameraPreview(controller)),
    );
  }
}