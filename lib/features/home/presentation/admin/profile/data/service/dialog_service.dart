import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

void showEditDialog(
  BuildContext context,
  String title,
  String currentValue,
  Function(String) onSave,
) {
  final controller = TextEditingController(text: currentValue);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      title: Text(
        'Edit $title',
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.mainTextColorBlack,
        ),
      ),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColors.mainTextColorBlack,
              width: 2,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onSave(controller.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainTextColorBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}