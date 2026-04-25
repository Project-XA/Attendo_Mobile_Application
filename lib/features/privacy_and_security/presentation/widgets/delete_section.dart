
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/action_button.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/info_box.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/password_field.dart';

class DeleteSection extends StatefulWidget {
  const DeleteSection({required this.isLoading, required this.onConfirm, super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoBox(
          color: const Color(0xFFFFF5F5),
          textColor: const Color(0xFFC62828),
          message: 'privacy.delete_info'.tr(),
          borderColor: const Color(0xFFFFD0D0),
        ),
        verticalSpace(14),
        Text(
          'privacy.delete_confirm_label'.tr(),
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF555555)),
        ),
        verticalSpace(6),
        TextField(
          controller: _confirmCtrl,
          decoration: InputDecoration(
            hintText: 'privacy.delete_confirm_word'.tr(),
          ),
          style: TextStyle(fontSize: 13.sp),
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
          color: const Color(0xFFE53935),
          outlined: true,
          enabled: _canDelete,
          onTap: () => widget.onConfirm(_passCtrl.text), 
        ),
      ],
    );
  }
}