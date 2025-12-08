// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class IdDataWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
 // final String idNumber;

  const IdDataWidget({
    super.key,
    required this.firstName,
    required this.lastName,
  //  required this.idNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backGroundColorWhite,
            AppColors.backGroundColorWhite.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.mainTextColorBlack.withOpacity(0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainTextColorBlack.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.mainTextColorBlack.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.mainTextColorBlack.withOpacity(0.03),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.green,
                    size: 20.w,
                  ),
                ),
                horizontalSpace(12),
                Text(
                  'ID Information',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.semiBold,
                    color: AppColors.mainTextColorBlack,
                  ),
                ),
              ],
            ),
          ),

          // Data Section
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildInfoCard(
                  icon: Icons.person_outline,
                  label: 'First Name',
                  value: firstName,
                ),
                verticalSpace(14.h),
                _buildInfoCard(
                  icon: Icons.person_outline,
                  label: 'Last Name',
                  value: lastName,
                ),
              
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.mainTextColorBlack.withOpacity(0.02)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isHighlighted
              ? AppColors.mainTextColorBlack.withOpacity(0.1)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.mainTextColorBlack.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 18.w,
              color: AppColors.mainTextColorBlack.withOpacity(0.6),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.mainTextColorBlack.withOpacity(0.5),
                  ),
                ),
                verticalSpace(4.h),
                Text(
                  value,
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeightHelper.semiBold,
                    color: AppColors.mainTextColorBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
