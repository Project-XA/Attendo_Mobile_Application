import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.label,
    required this.isLoading,
    required this.color,
    required this.onTap,
    this.outlined = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool isLoading;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || isLoading;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: outlined
                ? Colors.transparent
                : isDisabled
                    ? color.withOpacity(0.4)
                    : color,
            borderRadius: BorderRadius.circular(10.r),
            border: outlined
                ? Border.all(
                    color: isDisabled ? color.withOpacity(0.4) : color,
                    width: 1,
                  )
                : null,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: outlined ? color : Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.semiBold,
                      color: outlined
                          ? isDisabled
                              ? color.withOpacity(0.4)
                              : color
                          : Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}