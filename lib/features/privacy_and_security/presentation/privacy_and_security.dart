import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/logic/privacy_and_secuirty_state.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/logic/privacy_and_security_cubit.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/change_password_form.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/privacy_card.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/privacy_tile.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/section_label.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  late PrivacySecurityCubit _cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<PrivacySecurityCubit>();
  }

  @override
  void dispose() {
    _cubit.closeSection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<PrivacySecurityCubit, PrivacySecurityState>(
      listener: (context, state) {
        if (state.isSuccess &&
            state.activeAction == PrivacyAction.changePassword) {
          context.read<PrivacySecurityCubit>().closeSection();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('privacy.password_changed_success'.tr()),
              backgroundColor: AppColors.buttonGreenColor,
            ),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          title: Text(
            'privacy.title'.tr(),
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeightHelper.semiBold,
              color: colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<PrivacySecurityCubit, PrivacySecurityState>(
          builder: (context, state) {
            final cubit = context.read<PrivacySecurityCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(label: 'privacy.section_security'.tr()),
                  verticalSpace(8),
                  PrivacyCard(
                    children: [
                      PrivacyTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'privacy.change_password'.tr(),
                        subtitle: 'privacy.change_password_sub'.tr(),
                        isExpanded:
                            state.activeAction == PrivacyAction.changePassword,
                        onTap: () =>
                            state.activeAction == PrivacyAction.changePassword
                                ? cubit.closeSection()
                                : cubit.openSection(
                                    PrivacyAction.changePassword),
                        expandedChild: ChangePasswordForm(
                          isLoading: state.isLoading &&
                              state.activeAction == PrivacyAction.changePassword,
                          onSubmit: (current, newPass) =>
                              cubit.changePassword(
                            currentPassword: current,
                            newPassword: newPass,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}