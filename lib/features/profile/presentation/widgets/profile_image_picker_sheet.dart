import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/profile/presentation/widgets/image_source_option.dart';

class ProfileImagePickerSheet extends StatelessWidget {
  final void Function(File file) onImagePicked;

  const ProfileImagePickerSheet({super.key, required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'profile.choose_image_source'.tr(),
            style: AppTextStyle.font18GreyBold,
          ),
          verticalSpace(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageSourceOption(
                icon: Icons.camera_alt,
                label: 'profile.camera'.tr(),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    onImagePicked(File(image.path));
                  }
                },
              ),
              ImageSourceOption(
                icon: Icons.photo_library,
                label: 'profile.gallery'.tr(),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    onImagePicked(File(image.path));
                  }
                },
              ),
            ],
          ),
          verticalSpace(10.h),
        ],
      ),
    );
  }
}