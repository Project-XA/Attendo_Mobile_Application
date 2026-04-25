import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_image_picker_sheet.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_image_preview_dialog.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_camera_button.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        final user = context.read<CurrentUserCubit>().currentUser;
        final profileImage = user?.profileImage;

        return SizedBox(
          width: 110.w,
          height: 110.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Profile Image — tap to preview
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.85),
                  barrierDismissible: true,
                  builder: (_) =>
                      ProfileImagePreviewDialog(profileImage: profileImage),
                ),
                child: Hero(
                  tag: 'profile_image',
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: profileImage != null
                          ? Image.file(
                              File(profileImage),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/images/user.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),

              // Camera Button
              Positioned(
                bottom: 2,
                right: 2,
                child: ProfileCameraButton(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    builder: (_) => ProfileImagePickerSheet(
                      onImagePicked: (file) {
                        context.read<CurrentUserCubit>().updateProfileImage(
                          file,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}