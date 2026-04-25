import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class SearchingSessionsCard extends StatefulWidget {
  final int totalSearchDuration;
  final VoidCallback? onTimeout;
  final VoidCallback? onCancel; 

  const SearchingSessionsCard({
    super.key,
    required this.totalSearchDuration,
    this.onTimeout,
    this.onCancel, 
  });

  @override
  State<SearchingSessionsCard> createState() => _SearchingSessionsCardState();
}

class _SearchingSessionsCardState extends State<SearchingSessionsCard> {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.totalSearchDuration;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          widget.onTimeout?.call();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                Theme.of(context).colorScheme.onSurface.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              verticalSpace(24.h),
              _buildProgressIndicator(),
              verticalSpace(20.h),
              _buildTitle(),
              verticalSpace(8.h),
              _buildDescription(),
              verticalSpace(8.h),
              _buildTimeoutText(),
              verticalSpace(16.h),
              _buildStatusIndicators(),
              verticalSpace(20.h),
            ],
          ),
        ),

        if (widget.onCancel != null)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Tooltip(
              message: 'attendance.stop_searching'.tr(),
              child: GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  widget.onCancel?.call();
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60.w,
          height: 60.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            value: _secondsRemaining / widget.totalSearchDuration,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onSurface,
            ),
            backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        Text('$_secondsRemaining', style: AppTextStyle.font18BlackBold),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'attendance.searching_title'.tr(),
      style: AppTextStyle.font20BlackBold,
    );
  }

  Widget _buildDescription() {
    return Text(
      'attendance.searching_desc'.tr(),
      textAlign: TextAlign.center,
      style: AppTextStyle.font14Grey600Medium,
    );
  }

  Widget _buildTimeoutText() {
    return Text(
      'attendance.search_timeout'.tr(args: ['$_secondsRemaining']),
      style: AppTextStyle.font12Grey500Medium,
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusDot(true),
        horizontalSpace(8.w),
        _buildStatusDot(true),
        horizontalSpace(8.w),
        _buildStatusDot(false),
      ],
    );
  }

  Widget _buildStatusDot(bool isActive) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline.withOpacity(0.3),
      ),
    );
  }
}
