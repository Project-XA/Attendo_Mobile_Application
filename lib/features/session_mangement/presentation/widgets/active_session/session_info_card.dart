import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/info_row_widget.dart';

class SessionInfoCard extends StatefulWidget {
  final Session session;

  const SessionInfoCard({super.key, required this.session});

  @override
  State<SessionInfoCard> createState() => _SessionInfoCardState();
}

class _SessionInfoCardState extends State<SessionInfoCard> {
  bool _hasVibrated = false;

  Stream<Duration> countdownStream() async* {
    final endTime = widget.session.startTime.add(
      Duration(minutes: widget.session.durationMinutes),
    );

    while (true) {
      final now = DateTime.now();
      final remaining = endTime.difference(now);

      if (remaining.isNegative) {
        yield Duration.zero;
        break;
      }

      yield remaining;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _triggerVibration() {
    HapticFeedback.heavyImpact();

    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.mediumImpact();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      HapticFeedback.mediumImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: countdownStream(),
      builder: (context, snapshot) {
        final remaining = snapshot.data ?? Duration.zero;

        final totalDuration = Duration(minutes: widget.session.durationMinutes);

        final elapsed = totalDuration - remaining;

        final progress = (elapsed.inSeconds / totalDuration.inSeconds).clamp(
          0.0,
          1.0,
        );

        final isExpired = remaining == Duration.zero;
        final isWarning = remaining.inMinutes <= 5 && !isExpired;

        if (!_hasVibrated &&
            remaining.inMinutes <= 5 &&
            remaining.inMinutes >= 0) {
          _triggerVibration();
          _hasVibrated = true;
        }

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isExpired
                ? Colors.red.shade50
                : isWarning
                ? Colors.orange.shade50
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isExpired
                  ? Colors.red.shade200
                  : isWarning
                  ? Colors.orange.shade200
                  : Colors.green.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isExpired
                        ? Icons.cancel
                        : isWarning
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle,
                    color: isExpired
                        ? Colors.red
                        : isWarning
                        ? Colors.orange
                        : Colors.green,
                    size: 24.sp,
                  ),
                  horizontalSpace(8.w),
                  Text(
                    isExpired
                        ? 'Session Expired'
                        : isWarning
                        ? 'Session Ending Soon'
                        : 'Session Active',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: isExpired
                          ? Colors.red.shade800
                          : isWarning
                          ? Colors.orange.shade800
                          : Colors.green.shade800,
                    ),
                  ),
                ],
              ),

              verticalSpace(16.h),

              _buildTimeRemaining(remaining, isExpired, isWarning),

              verticalSpace(12.h),

              _buildProgressBar(progress, isExpired, isWarning),

              verticalSpace(16.h),

              InfoRow(label: 'Session Name:', value: widget.session.name),
              verticalSpace(8.h),
              InfoRow(label: 'Location:', value: widget.session.location),
              verticalSpace(8.h),
              InfoRow(
                label: 'Connection:',
                value: widget.session.connectionMethod,
              ),
              verticalSpace(8.h),
              InfoRow(
                label: 'Start Time:',
                value: DateFormat('hh:mm a').format(widget.session.startTime),
              ),
              verticalSpace(8.h),
              InfoRow(
                label: 'Duration:',
                value: '${widget.session.durationMinutes} minutes',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeRemaining(
    Duration remaining,
    bool isExpired,
    bool isWarning,
  ) {
    if (isExpired) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_off, color: Colors.red, size: 20.sp),
            horizontalSpace(8.w),
            Text(
              'Session Time Expired',
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeightHelper.bold,
                color: Colors.red.shade900,
              ),
            ),
          ],
        ),
      );
    }

    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    final hours = remaining.inHours;

    final timeString = hours > 0
        ? "$hours:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}"
        : "$minutes:${seconds.toString().padLeft(2, "0")}";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isWarning ? Colors.orange.shade100 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isWarning ? Colors.orange : Colors.blue,
            size: 20.sp,
          ),
          horizontalSpace(8.w),
          Text(
            timeString,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              color: isWarning ? Colors.orange.shade900 : Colors.blue.shade900,
            ),
          ),
          horizontalSpace(6.w),
          Text(
            "remaining",
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              color: isWarning ? Colors.orange.shade700 : Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, bool isExpired, bool isWarning) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Session Progress",
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeightHelper.bold,
                color: isExpired
                    ? Colors.red
                    : isWarning
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
          ],
        ),
        verticalSpace(6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8.h,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isExpired
                  ? Colors.red
                  : isWarning
                  ? Colors.orange
                  : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
