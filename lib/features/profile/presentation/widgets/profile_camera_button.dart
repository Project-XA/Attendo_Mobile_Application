import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCameraButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileCameraButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 1),
        ),
        child: Icon(
          Icons.camera_alt,
          size: 16.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}