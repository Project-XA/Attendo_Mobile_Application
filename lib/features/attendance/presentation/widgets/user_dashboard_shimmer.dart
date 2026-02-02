import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class UserDashboardShimmer extends StatelessWidget {
  const UserDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isSmallScreen),
            verticalSpace(20),

            // Info Card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12.w : 20.w,
                vertical: 8.h,
              ),
              child: _buildInfoCard(isSmallScreen),
            ),

            verticalSpace(20.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Session Card
                    _buildSessionCard(isSmallScreen),
                    verticalSpace(20.h),

                    // My Attendance Section
                    _buildMyAttendanceHeader(isSmallScreen),
                    verticalSpace(12.h),
                    _buildAttendanceStatsCard(isSmallScreen),
                    verticalSpace(20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Header ====================
  Widget _buildHeader(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12.w : 16.w,
        vertical: 8.h,
      ),
      child: Row(
        children: [
          // Avatar Shimmer
          Shimmer(
            duration: const Duration(seconds: 3),
            color: Colors.grey[100]!,
            colorOpacity: 0.3,
            child: Container(
              width: isSmallScreen ? 45.w : 50.w,
              height: isSmallScreen ? 45.w : 50.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: isSmallScreen ? 10.w : 12.w),

          // Name and Role Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name
                Shimmer(
                  duration: const Duration(seconds: 3),
                  color: Colors.grey[100]!,
                  colorOpacity: 0.3,
                  child: Container(
                    width: 120.w,
                    height: isSmallScreen ? 14.h : 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                verticalSpace(4.h),
                // Role
                Shimmer(
                  duration: const Duration(seconds: 3),
                  color: Colors.grey[100]!,
                  colorOpacity: 0.3,
                  child: Container(
                    width: 60.w,
                    height: isSmallScreen ? 11.h : 14.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification Icon Shimmer
          Shimmer(
            duration: const Duration(seconds: 3),
            color: Colors.grey[100]!,
            colorOpacity: 0.3,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Info Card ====================
  Widget _buildInfoCard(bool isSmallScreen) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmallScreen ? 16.w : 20.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              width: 150.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            verticalSpace(8.h),
            // Subtitle
            Container(
              width: 200.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            verticalSpace(8.h),
            // Description
            Container(
              width: 180.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Session Card (Ready to Search) ====================
  Widget _buildSessionCard(bool isSmallScreen) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
            ),
            verticalSpace(16.h),
            // Title
            Container(
              width: 150.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            verticalSpace(8.h),
            // Subtitle
            Container(
              width: 200.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            verticalSpace(20.h),
            // Button
            Container(
              width: double.infinity,
              height: isSmallScreen ? 50.h : 56.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== My Attendance Header ====================
  Widget _buildMyAttendanceHeader(bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // "My Attendance" text
        Shimmer(
          duration: const Duration(seconds: 3),
          color: Colors.grey[100]!,
          colorOpacity: 0.3,
          child: Container(
            width: 120.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        // "View All" button
        Shimmer(
          duration: const Duration(seconds: 3),
          color: Colors.grey[100]!,
          colorOpacity: 0.3,
          child: Container(
            width: 60.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Attendance Stats Card ====================
  Widget _buildAttendanceStatsCard(bool isSmallScreen) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.backGroundColorWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Total
            Expanded(child: _buildStatItemShimmer(isSmallScreen)),
            Container(width: 1, height: 50.h, color: Colors.grey[200]),
            // Attended
            Expanded(child: _buildStatItemShimmer(isSmallScreen)),
            Container(width: 1, height: 50.h, color: Colors.grey[200]),
            // Rate
            Expanded(child: _buildStatItemShimmer(isSmallScreen)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItemShimmer(bool isSmallScreen) {
    return Column(
      children: [
        // Icon
        Container(
          width: 24.sp,
          height: 24.sp,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
        ),
        verticalSpace(8.h),
        // Value
        Container(
          width: 40.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        verticalSpace(4.h),
        // Label
        Container(
          width: 50.w,
          height: 11.h,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}
