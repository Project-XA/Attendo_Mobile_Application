// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_user_home.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_cubit.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_state.dart';
import 'package:mobile_app/feature/home/presentation/widgets/info_card.dart';
import 'package:mobile_app/feature/home/presentation/widgets/user_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _searchTimer;
  int _searchSecondsRemaining = 30;
  final int _totalSearchDuration = 30; // يمكن تغييره

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  void _startSearchTimer() {
    _searchTimer?.cancel();
    setState(() => _searchSecondsRemaining = _totalSearchDuration);

    _searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_searchSecondsRemaining > 0) {
            _searchSecondsRemaining--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  void _stopSearchTimer() {
    _searchTimer?.cancel();
    if (mounted) {
      setState(() => _searchSecondsRemaining = _totalSearchDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    initUserHome();

    return BlocProvider(
      create: (context) => getIt<UserCubit>()..loadUser(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            // إدارة الـ timer بناءً على حالة البحث
            if (state is SessionDiscoveryActive && state.isSearching) {
              _startSearchTimer();
            } else {
              _stopSearchTimer();
            }
          },
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              // Loading state
              if (state is UserLoading || state is UserInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error state
              if (state is UserError) {
                return _buildErrorView(context, state.message);
              }

              // Get user from state
              final user = state is UserStateWithUser ? state.user : null;
              if (user == null) {
                return const Center(child: Text('No user data'));
              }

              return SafeArea(
                child: Column(
                  children: [
                    UserHeader(
                      userName: user.fullNameEn,
                      userRole: user.organizations?.first.role ?? 'Student',
                      userImage: user.profileImage ?? Assets.assetsImagesUser,
                      notificationCount: 3,
                      onNotificationTap: () {},
                    ),

                    verticalSpace(20),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12.w : 20.w,
                        vertical: 8.h,
                      ),
                      child: const InfoCard(
                        title: 'Welcome Back!',
                        subtitle: 'Assuit University',
                        description: 'Check attendance and active sessions',
                      ),
                    ),

                    verticalSpace(20.h),

                    Expanded(child: _buildContent(context, state)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          verticalSpace(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ),
          verticalSpace(16.h),
          ElevatedButton(
            onPressed: () => context.read<UserCubit>().loadUser(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    // Check-in in progress
    if (state is CheckInState) {
      return _buildCheckInView(context, state);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActiveSessionCard(context, state),
          verticalSpace(20.h),
          _buildMyAttendanceSection(context, state),
          verticalSpace(20.h),
        ],
      ),
    );
  }

  Widget _buildCheckInView(BuildContext context, CheckInState state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.isLoading) ...[
              const CircularProgressIndicator(),
              verticalSpace(24.h),
              Text(
                'Checking In...',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeightHelper.semiBold,
                ),
              ),
              verticalSpace(12.h),
              Text(
                'Please wait',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ] else if (state.isSuccess) ...[
              Icon(Icons.check_circle, color: Colors.green, size: 100.sp),
              verticalSpace(24.h),
              Text(
                'Check-In Successful!',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: Colors.green,
                ),
              ),
              verticalSpace(12.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    _buildSuccessRow(
                      Icons.event,
                      'Session',
                      state.session.name,
                    ),
                    verticalSpace(8.h),
                    _buildSuccessRow(
                      Icons.location_on,
                      'Location',
                      state.session.location,
                    ),
                    verticalSpace(8.h),
                    _buildSuccessRow(
                      Icons.access_time,
                      'Time',
                      DateFormat('hh:mm a').format(state.checkInTime!),
                    ),
                  ],
                ),
              ),
            ] else if (state.isFailed) ...[
              Icon(Icons.error, color: Colors.red, size: 100.sp),
              verticalSpace(24.h),
              Text(
                'Check-In Failed',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: Colors.red,
                ),
              ),
              verticalSpace(12.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  state.errorMessage ?? 'Please try again',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 14.sp,
                    color: Colors.red.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.green.shade700),
        horizontalSpace(8.w),
        Text(
          '$label:',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 13.sp,
            color: Colors.grey.shade700,
          ),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeightHelper.medium,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSessionCard(BuildContext context, UserState state) {
    final hasActiveSession =
        state is SessionDiscoveryActive &&
        state.activeSession != null &&
        !state.isSearching;
    final isSearching = state is SessionDiscoveryActive && state.isSearching;

    if (isSearching) {
      return _buildSearchingCard();
    }

    if (!hasActiveSession) {
      return _buildNoActiveSessionCard(context, state);
    }

    final session = (state).activeSession!;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainTextColorBlack,
            AppColors.mainTextColorBlack.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.wifi, color: Colors.white, size: 24.sp),
              ),
              horizontalSpace(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Session Nearby',
                      style: AppTextStyle.font14MediamGrey.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: Colors.white,
                      ),
                    ),
                    verticalSpace(4.h),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 8.sp),
                        horizontalSpace(6.w),
                        Text(
                          'Live Now',
                          style: AppTextStyle.font14MediamGrey.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          verticalSpace(16.h),

          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildSessionInfoRow(
                  Icons.event_note,
                  'Session:',
                  session.name,
                ),
                verticalSpace(8.h),
                _buildSessionInfoRow(
                  Icons.location_on,
                  'Location:',
                  session.location,
                ),
                verticalSpace(8.h),
                _buildSessionInfoRow(
                  Icons.access_time,
                  'Time:',
                  '${DateFormat('hh:mm a').format(session.startTime)} - ${DateFormat('hh:mm a').format(session.endTime)}',
                ),
                verticalSpace(8.h),
                _buildSessionInfoRow(
                  Icons.people,
                  'Attendees:',
                  '${session.attendeeCount} Students',
                ),
              ],
            ),
          ),

          verticalSpace(16.h),

          CustomAppButton(
            onPressed: () => context.read<UserCubit>().checkIn(session),
            backgroundColor: Colors.white,
            borderRadius: 20.r,
            width: double.infinity,
            height: 50.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.mainTextColorBlack,
                  size: 20.sp,
                ),
                horizontalSpace(8.w),
                Text(
                  'Check In Now',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: AppColors.mainTextColorBlack,
                    fontWeight: FontWeightHelper.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mainTextColorBlack.withOpacity(0.05),
            AppColors.mainTextColorBlack.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.mainTextColorBlack.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Animated icon container
          // Container(
          //   padding: EdgeInsets.all(20.w),
          //   decoration: BoxDecoration(
          //     color: AppColors.mainTextColorBlack.withOpacity(0.05),
          //     shape: BoxShape.circle,
          //   ),
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Container(
          //         width: 80.sp,
          //         height: 80.sp,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           border: Border.all(
          //             color: AppColors.mainTextColorBlack.withOpacity(0.2),
          //             width: 2,
          //           ),
          //         ),
          //       ),
          //       // Inner icon
          //       Icon(
          //         Icons.radar,
          //         size: 40.sp,
          //         color: AppColors.mainTextColorBlack,
          //       ),
          //     ],
          //   ),
          // ),
          verticalSpace(24.h),

          // Progress indicator مع countdown
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60.w,
                height: 60.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  value: _searchSecondsRemaining / _totalSearchDuration,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.mainTextColorBlack,
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              Text(
                '$_searchSecondsRemaining',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: AppColors.mainTextColorBlack,
                ),
              ),
            ],
          ),

          verticalSpace(20.h),

          Text(
            'Searching for Sessions',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeightHelper.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),

          verticalSpace(8.h),

          Text(
            'Scanning nearby locations for\nactive attendance sessions',
            textAlign: TextAlign.center,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),

          verticalSpace(8.h),

          // عداد بالثواني
          Text(
            'Timeout in ${_searchSecondsRemaining}s',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),

          verticalSpace(16.h),

          // Status indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusDot(true),
              horizontalSpace(8.w),
              _buildStatusDot(true),
              horizontalSpace(8.w),
              _buildStatusDot(false),
            ],
          ),

          verticalSpace(20.h),

          // Cancel button
        ],
      ),
    );
  }

  Widget _buildStatusDot(bool isActive) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.mainTextColorBlack : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildNoActiveSessionCard(BuildContext context, UserState state) {
    // Check if user is in idle state (hasn't started discovery)
    final isIdle = state is UserIdle;
    final isDiscoveryActive = state is SessionDiscoveryActive;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade100, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon container with gradient background
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIdle ? Icons.search : Icons.wifi_off_rounded,
              size: 56.sp,
              color: AppColors.mainTextColorBlack,
            ),
          ),

          verticalSpace(20.h),

          Text(
            isIdle ? 'Ready to Search' : 'No Sessions Found',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeightHelper.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),

          verticalSpace(12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              isIdle
                  ? 'Start searching to discover active\nattendance sessions nearby'
                  : 'No active sessions were found in your area.\nSessions may have ended or moved.',
              textAlign: TextAlign.center,
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ),

          verticalSpace(18.h),

          // Action button
          CustomAppButton(
            onPressed: () {
              if (isIdle) {
                context.read<UserCubit>().startSessionDiscovery();
              } else {
                context.read<UserCubit>().refreshSessions();
              }
            },
            backgroundColor: AppColors.mainTextColorBlack,

            borderRadius: 16.r,
            width: 200.w,
            height: 48.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isIdle ? Icons.search : Icons.refresh,
                  color: Colors.white,
                  size: 20.sp,
                ),
                horizontalSpace(10.w),
                Text(
                  isIdle ? 'Start Search' : 'Search Again',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeightHelper.semiBold,
                  ),
                ),
              ],
            ),
          ),

          if (isDiscoveryActive) ...[
            verticalSpace(16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16.sp,
                    color: Colors.orange.shade700,
                  ),
                  horizontalSpace(8.w),
                  Text(
                    'Make sure you\'re close to the venue',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 12.sp,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 16.sp),
        horizontalSpace(8.w),
        Text(
          label,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeightHelper.medium,
              color: Colors.white,
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMyAttendanceSection(BuildContext context, UserState state) {
    final stats = state is UserStateWithUser
        ? (state is SessionDiscoveryActive
              ? state.stats
              : state is UserIdle
              ? state.stats
              : null)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Attendance',
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              // () =>
              //     context.read<UserCubit>().loadAttendanceHistory(),
              child: Text(
                'View All',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.mainTextColorBlack,
                ),
              ),
            ),
          ],
        ),

        verticalSpace(12.h),

        if (stats != null) _buildAttendanceStatsCard(stats),
      ],
    );
  }

  Widget _buildAttendanceStatsCard(stats) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total',
              '${stats.totalSessions}',
              Icons.event,
              Colors.blue,
            ),
          ),
          Container(width: 1, height: 50.h, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'Attended',
              '${stats.attendedSessions}',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          Container(width: 1, height: 50.h, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'Rate',
              '${stats.attendancePercentage.toStringAsFixed(0)}%',
              Icons.percent,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        verticalSpace(8.h),
        Text(
          value,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        verticalSpace(4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
