// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/camera_box.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/cropped_field_viewer.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/scan_header.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/action_buttons.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';

class ScanIdScreen extends StatelessWidget {
  const ScanIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraCubit(CameraRepImp()),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScanHeader(),
                  verticalSpace(30),

                  const CameraBox(),
                  verticalSpace(20),

                  if (state.showResult && state.croppedFields != null) ...[
                    Expanded(
                      child: CroppedFieldsViewer(
                        croppedFields: state.croppedFields!,
                        extractedText: state.extractedText,
                      ),
                    ),
                    verticalSpace(20),
                  ],

                  if (!state.showResult) const Spacer(),

                  ActionButtons(state: state),
                  verticalSpace(20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.mainTextColorBlack,
        ),
      ),
      centerTitle: true,
      title: Text(
        'ID Verification',
        style: TextStyle(
          fontWeight: FontWeightHelper.semiBold,
          fontSize: 18.sp,
          color: AppColors.mainTextColorBlack,
        ),
      ),
    );
  }
}
