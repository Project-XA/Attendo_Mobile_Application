import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

/// A reusable password field with a visibility toggle.
/// Default colours match the light-mode field style used across the student auth feature.
class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  /// Override colours only when placing this field on a non-standard background.
  final Color backgroundColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color iconColor;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.focusedBorderColor = AppColors.mainBackgroundDarkColor,
    this.enabledBorderColor = const Color(0xFFE0E0E0),
    this.iconColor = const Color(0xFFBDBDBD),
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      hintText: widget.hintText,
      borderRadius: 14.r,
      backgroundColor: widget.backgroundColor,
      enabledBorderColor: widget.enabledBorderColor,
      focusedBorderColor: widget.focusedBorderColor,
      textStyle: TextStyle(
        color: AppColors.mainBackgroundDarkColor,
        fontSize: 14.sp,
      ),
      obscureText: !_isVisible,
      label: Icon(
        Icons.lock_outline_rounded,
        color: widget.iconColor,
        size: 20,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: widget.iconColor,
          size: 20,
        ),
        onPressed: () => setState(() => _isVisible = !_isVisible),
      ),
      validator: widget.validator,
    );
  }
}