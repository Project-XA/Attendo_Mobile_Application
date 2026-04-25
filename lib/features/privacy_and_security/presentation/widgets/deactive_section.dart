import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/action_button.dart' show ActionButton;
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/info_box.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/password_field.dart';

class DeactivateSection extends StatefulWidget {
  const DeactivateSection({
    required this.isLoading,
    required this.onConfirm,
    super.key,
  });

  final bool isLoading;
  final void Function(String password) onConfirm;

  @override
  State<DeactivateSection> createState() => _DeactivateSectionState();
}

class _DeactivateSectionState extends State<DeactivateSection> {
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoBox(
          color: const Color(0xFFFFF8E1),
          textColor: const Color(0xFFE65100),
          message: 'privacy.deactivate_info'.tr(),
          borderColor: const Color(0xFFFFE082),
        ),
        verticalSpace(14),
        PasswordField(
          label: 'privacy.confirm_with_password'.tr(),
          controller: _passCtrl,
          obscure: _obscure,
          onToggle: () => setState(() => _obscure = !_obscure),
        ),
        verticalSpace(14),
        ActionButton(
          label: 'privacy.deactivate_btn'.tr(),
          isLoading: widget.isLoading,
          color: const Color(0xFFE65100),
          outlined: true,
          enabled: _passCtrl.text.isNotEmpty,
          onTap: () => widget.onConfirm(_passCtrl.text),
        ),
      ],
    );
  }
}
