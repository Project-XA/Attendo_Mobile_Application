import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImagePreviewDialog extends StatelessWidget {
  final String? profileImage;

  const ProfileImagePreviewDialog({super.key, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Tap outside to dismiss
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          // Image centered with zoom
          Center(
            child: GestureDetector(
              onTap: () {}, // prevent dismiss on image tap
              child: Hero(
                tag: 'profile_image',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: profileImage != null
                        ? Image.file(
                            File(profileImage!),
                            width: 300.w,
                            height: 300.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              "assets/images/user.png",
                              width: 300.w,
                              height: 300.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            "assets/images/user.png",
                            width: 300.w,
                            height: 300.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: 40.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 20.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
