import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/action_button.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/info_box.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/password_field.dart';

class DeleteSection extends StatefulWidget {
  const DeleteSection({
    required this.isLoading,
    required this.onConfirm,
    super.key,
  });

  final bool isLoading;
  final void Function(String password) onConfirm;

  @override
  State<DeleteSection> createState() => _DeleteSectionState();
}

class _DeleteSectionState extends State<DeleteSection> {
  final _confirmCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _canDelete = false;

  @override
  void initState() {
    super.initState();
    void check() {
      final word = 'privacy.delete_confirm_word'.tr();
      setState(
        () => _canDelete =
            _confirmCtrl.text.trim() == word && _passCtrl.text.isNotEmpty,
      );
    }

    _confirmCtrl.addListener(check);
    _passCtrl.addListener(check);
  }

  @override
  void dispose() {
    _confirmCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoBox(
          color: isDark
              ? AppColors.elevatedSurfaceDarkColor
              : AppColors.statusGreenBackgroundColor,
          textColor: isDark
              ? AppColors.subTextDarkColor
              : colorScheme.error,
          borderColor: isDark
              ? AppColors.borderDarkColor
              : colorScheme.error.withOpacity(0.3),
          message: 'privacy.delete_info'.tr(),
        ),
        verticalSpace(14),
        Text(
          'privacy.delete_confirm_label'.tr(),
          style: TextStyle(fontSize: 12.sp, color: colorScheme.outline),
        ),
        verticalSpace(6),
        TextField(
          controller: _confirmCtrl,
          style: TextStyle(fontSize: 13.sp, color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'privacy.delete_confirm_word'.tr(),
          ),
        ),
        verticalSpace(10),
        PasswordField(
          label: 'privacy.confirm_with_password'.tr(),
          controller: _passCtrl,
          obscure: _obscure,
          onToggle: () => setState(() => _obscure = !_obscure),
        ),
        verticalSpace(14),
        ActionButton(
          label: 'privacy.delete_btn'.tr(),
          isLoading: widget.isLoading,
          outlined: true,
          enabled: _canDelete,
          onTap: () => widget.onConfirm(_passCtrl.text),
          variant: ActionButtonVariant.danger,
        ),
      ],
    );
  }
}