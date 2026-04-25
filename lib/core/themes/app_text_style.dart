import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class AppTextStyle {
  static TextStyle font15White = TextStyle(
    fontSize: 15.sp,
    color: AppColors.mainBackgroundWhiteColor,
  );

  static TextStyle font15WhiteBold = font15White.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font14Grey = TextStyle(
    fontSize: 14.sp,
    color: AppColors.subTextGreyColor,
  );

  static TextStyle font14GreyRegular = font14Grey.copyWith();

  static TextStyle font14GreyMedium = font14Grey.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font14GreyBold = font14Grey.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font14Grey400 = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey.shade400,
  );

  static TextStyle font14Grey400Regular = font14Grey400.copyWith(
    fontWeight: FontWeightHelper.regular,
  );

  static TextStyle font14Black = TextStyle(
    fontSize: 14.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font14BlackMedium = font14Black.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font14BlackBold = font14Black.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font14BlackRegular = font14Black.copyWith();

  static TextStyle font20Black = TextStyle(
    fontSize: 20.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font20BlackBold = font20Black.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font13Black = TextStyle(
    fontSize: 13.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font13BlackMedium = TextStyle(
    fontSize: 13.sp,
    color: AppColors.mainTextBlackColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font24Black = TextStyle(
    fontSize: 24.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font24BlackBold = font24Black.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle font24White = TextStyle(
    fontSize: 24.sp,
    color: AppColors.mainBackgroundWhiteColor,
  );

  static TextStyle font24WhiteBold = font24White.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font12White = TextStyle(
    fontSize: 12.sp,
    color: AppColors.mainBackgroundWhiteColor,
  );

  static TextStyle font12WhiteMedium = TextStyle(
    fontSize: 12.sp,
    color: AppColors.mainBackgroundWhiteColor,
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font12WhiteBold = font12White.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font16Grey600 = TextStyle(
    fontSize: 16.sp,
    color: Colors.grey.shade600,
  );

  static TextStyle font16Grey600Medium = font16Grey600.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font12Grey600 = TextStyle(
    fontSize: 12.sp,
    color: Colors.grey.shade600,
  );

  static TextStyle font12Grey600Medium = font12Grey600.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font13Grey = TextStyle(
    fontSize: 13.sp,
    color: AppColors.subTextGreyColor,
  );

  static TextStyle font13GreyMedium = font13Grey.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font11Grey600 = TextStyle(
    fontSize: 11.sp,
    color: Colors.grey.shade600,
  );

  static TextStyle font11Grey600Medium = font11Grey600.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font12Grey = TextStyle(
    fontSize: 12.sp,
    color: AppColors.subTextGreyColor,
  );

  static TextStyle font12GreyBold = font12Grey.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font13Grey600 = TextStyle(
    fontSize: 13.sp,
    color: Colors.grey.shade600,
  );

  static TextStyle font13Grey600Medium = font13Grey600.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font13Red700 = TextStyle(
    fontSize: 13.sp,
    color: Colors.red.shade700,
  );

  static TextStyle font13Red700Medium = font13Red700.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font13Orange700 = TextStyle(
    fontSize: 13.sp,
    color: Colors.orange.shade700,
  );

  static TextStyle font13Orange700Medium = font13Orange700.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font16Orange900 = TextStyle(
    fontSize: 16.sp,
    color: Colors.orange.shade900,
  );

  static TextStyle font16Orange900Bold = font16Orange900.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font16White = TextStyle(
    fontSize: 16.sp,
    color: AppColors.mainBackgroundWhiteColor,
  );

  static TextStyle font16WhiteMedium = font16White.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font16Black = TextStyle(
    fontSize: 16.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font16BlackMedium = font16Black.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font16BlackBold = font16Black.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font18Black = TextStyle(
    fontSize: 18.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font18BlackSemiBold = font18Black.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle font18BlackBold = font18Black.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font16Red900 = TextStyle(
    fontSize: 16.sp,
    color: Colors.red.shade900,
  );

  static TextStyle font16Red900Bold = font16Red900.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font14Grey600 = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey.shade600,
  );

  static TextStyle font14Grey600Medium = font14Grey600.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font32Black = TextStyle(
    fontSize: 32.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font32BlackBold = font32Black.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font12Green700 = TextStyle(
    fontSize: 12.sp,
    color: Colors.green.shade700,
  );

  static TextStyle font12Green700Bold = font12Green700.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font14White = TextStyle(
    fontSize: 14.sp,
    color: AppColors.mainBackgroundWhiteColor,
  );

  static TextStyle font14WhiteBold = font14White.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font15Black = TextStyle(
    fontSize: 15.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font15BlackBold = font15Black.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font15BlackMedium = font15Black.copyWith(
    fontWeight: FontWeight.w500,
  );

  static TextStyle font10White = TextStyle(
    fontSize: 10.sp,
    color: AppColors.mainBackgroundWhiteColor,
  );

  static TextStyle font10WhiteBold = font10White.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font12Grey500 = TextStyle(
    fontSize: 12.sp,
    color: Colors.grey.shade500,
  );

  static TextStyle font12Grey500Medium = font12Grey500.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font14Red900 = TextStyle(
    fontSize: 14.sp,
    color: Colors.red.shade900,
  );

  static TextStyle font14Red900Bold = font14Red900.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font16Blue800 = TextStyle(
    fontSize: 16.sp,
    color: Colors.blue.shade800,
  );

  static TextStyle font16Blue800Bold = font16Blue800.copyWith(
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font22White = TextStyle(
    fontSize: 22.sp,
    color: AppColors.onDarkForegroundWhiteColor,
  );

  static TextStyle font22WhiteBold = font22White.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle font14WhiteMedium = TextStyle(
    fontSize: 14.sp,
    color: AppColors.mainBackgroundWhiteColor,
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font18Grey = TextStyle(
    fontSize: 18.sp,
    color: AppColors.subTextGreyColor,
  );

  static TextStyle font18GreyBold = font18Grey.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle font20White = TextStyle(
    fontSize: 20.sp,
    color: AppColors.onDarkForegroundWhiteColor,
  );

  static TextStyle font20WhiteBold = font20White.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font18White = TextStyle(
    fontSize: 18.sp,
    color: AppColors.onDarkForegroundWhiteColor,
  );

  static TextStyle font18WhiteBold = font18White.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font13White = TextStyle(
    fontSize: 13.sp,
    color: AppColors.onDarkForegroundWhiteColor,
  );

  static TextStyle font13WhiteMedium = font13White.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font14Red700 = TextStyle(
    fontSize: 14.sp,
    color: Colors.red.shade700,
  );

  static TextStyle font14Red700Medium = font14Red700.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font20Grey = TextStyle(
    fontSize: 20.sp,
    color: AppColors.subTextGreyColor,
  );

  static TextStyle font20GreyBold = font20Grey.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font13Grey700 = TextStyle(
    fontSize: 13.sp,
    color: Colors.grey.shade700,
  );

  static TextStyle font13Grey700Medium = font13Grey700.copyWith(
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font22Black = TextStyle(
    fontSize: 22.sp,
    color: AppColors.mainTextBlackColor,
  );

  static TextStyle font22BlackBold = font22Black.copyWith(
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font12Orange700 = TextStyle(
    fontSize: 12.sp,
    color: Colors.orange.shade700,
  );

  static TextStyle font12Orange700Medium = font12Orange700.copyWith(
    fontWeight: FontWeightHelper.medium,
  );
}