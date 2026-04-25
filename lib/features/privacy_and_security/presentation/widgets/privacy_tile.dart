import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class PrivacyTile extends StatelessWidget {
  const PrivacyTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isExpanded,
    required this.onTap,
    required this.expandedChild,
    this.titleColor,
    this.showDivider = false,
    super.key,
    
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget expandedChild;
  final Color? titleColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 18.sp),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeightHelper.semiBold,
                          color: titleColor ?? const Color(0xFF1A1A1A),
                        ),
                      ),
                      verticalSpace(2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFFCCCCCC),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Container(
                  width: double.infinity,
                  decoration:const BoxDecoration(
                    color:  Color(0xFFF7FBFD),
                    border: Border(
                      top: BorderSide(
                        color:  Color(0xFFE8F0F4),
                        width: 0.5,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: expandedChild,
                )
              : const SizedBox.shrink(),
        ),
        if (showDivider)
          Divider(
            height: 0,
            thickness: 0.5,
            color: const Color(0xFFF0F0F0),
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}