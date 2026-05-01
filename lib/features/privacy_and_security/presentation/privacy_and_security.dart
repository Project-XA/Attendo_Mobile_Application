import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/logic/privacy_and_secuirty_state.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/logic/privacy_and_security_cubit.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/change_password_form.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/deactive_section.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/widgets/delete_section.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<PrivacySecurityCubit, PrivacySecurityState>(
      listener: (context, state) {
        if (state.isSuccess) {
          if (state.activeAction == PrivacyAction.changePassword) {
            context.read<PrivacySecurityCubit>().closeSection();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('privacy.password_changed_success'.tr()),
                backgroundColor: AppColors.buttonGreenColor,
              ),
            );
          } else if (state.activeAction == PrivacyAction.deactivate ||
              state.activeAction == PrivacyAction.delete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.startPage,
                (route) => false,
              );
            });
          }
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: colorScheme.error,
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
            icon: const Icon(Icons.arrow_back_ios),
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
                        isExpanded: state.activeAction == PrivacyAction.changePassword,
                        onTap: () =>
                            state.activeAction == PrivacyAction.changePassword
                                ? cubit.closeSection()
                                : cubit.openSection(PrivacyAction.changePassword),
                        expandedChild: ChangePasswordForm(
                          isLoading:
                              state.isLoading &&
                              state.activeAction == PrivacyAction.changePassword,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(24),
                  SectionLabel(label: 'privacy.section_account'.tr()),
                  verticalSpace(8),
                  PrivacyCard(
                    children: [
                      PrivacyTile(
                        icon: Icons.pause_circle_outline_rounded,
                        tileVariant: PrivacyTileVariant.warning,
                        title: 'privacy.deactivate'.tr(),
                        subtitle: 'privacy.deactivate_sub'.tr(),
                        isExpanded: state.activeAction == PrivacyAction.deactivate,
                        onTap: () =>
                            state.activeAction == PrivacyAction.deactivate
                                ? cubit.closeSection()
                                : cubit.openSection(PrivacyAction.deactivate),
                        expandedChild: DeactivateSection(
                          isLoading:
                              state.isLoading &&
                              state.activeAction == PrivacyAction.deactivate,
                          onConfirm: cubit.deactivateAccount,
                        ),
                        showDivider: true,
                      ),
                      PrivacyTile(
                        icon: Icons.delete_outline_rounded,
                        tileVariant: PrivacyTileVariant.danger,
                        title: 'privacy.delete'.tr(),
                        subtitle: 'privacy.delete_sub'.tr(),
                        isExpanded: state.activeAction == PrivacyAction.delete,
                        onTap: () =>
                            state.activeAction == PrivacyAction.delete
                                ? cubit.closeSection()
                                : cubit.openSection(PrivacyAction.delete),
                        expandedChild: DeleteSection(
                          isLoading:
                              state.isLoading &&
                              state.activeAction == PrivacyAction.delete,
                          onConfirm: cubit.deleteAccount,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}