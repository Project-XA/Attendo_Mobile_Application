import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_camera_button.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_image_picker_sheet.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_image_preview_dialog.dart';

class StudentProfileImageSection extends StatelessWidget {
  const StudentProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentStudentCubit, CurrentStudentState>(
      builder: (context, state) {
        final profileImage = state.student?.profileImage;

        return SizedBox(
          width: 110.w,
          height: 110.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.85),
                  barrierDismissible: true,
                  builder: (_) =>
                      ProfileImagePreviewDialog(profileImage: profileImage),
                ),
                child: Hero(
                  tag: 'student_profile_image',
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
                        context
                            .read<CurrentStudentCubit>()
                            .updateProfileImage(file);
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