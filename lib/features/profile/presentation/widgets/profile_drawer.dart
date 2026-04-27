import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/themes/theme_cubit.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/theme_transition_manager.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'settings.title'.tr(),
              style: AppTextStyle.font22WhiteBold.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            verticalSpace(8),
            Divider(color: theme.dividerTheme.color),
            verticalSpace(16),

            _DrawerItem(
              icon: Icons.language_rounded,
              label: 'settings.language'.tr(),
              onTap: () => _showLanguageDialog(context),
            ),

            verticalSpace(8),

            _DarkModeToggle(isDark: isDark),

            // _DrawerItem(
            //   icon: Icons.privacy_tip_rounded,
            //   label: 'settings.privacy'.tr(),
            //   onTap: () {
            //     context.pushNamed(Routes.privacyAndSecurityScreen);
            //   },
            // ),
            const Spacer(),

            Divider(color: theme.dividerTheme.color),
            verticalSpace(12),

            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'profile.logout_title'.tr(),
              color: Colors.redAccent.shade100,
              onTap: () {
                drawerController.hideDrawer();
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'settings.language'.tr(),
          style: AppTextStyle.font18GreyBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageTile(
              flag: '🇺🇸',
              label: 'settings.language_english'.tr(),
              locale: const Locale('en'),
            ),
            verticalSpace(8),
            _LanguageTile(
              flag: '🇪🇬',
              label: 'settings.language_arabic'.tr(),
              locale: const Locale('ar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'profile.logout_title'.tr(),
          style: AppTextStyle.font18GreyBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'profile.logout_confirm'.tr(),
          style: AppTextStyle.font14GreyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'common.cancel'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final onboardingService = getIt<OnboardingService>();
                await onboardingService.logout();
                if (!context.mounted) return;
                context.pushNameAndRemoveUntil(
                  Routes.registerScreen,
                  predicate: (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('profile.logout_failed'.tr(args: ['$e'])),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'profile.logout_title'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dark Mode Toggle Row ────────────────────────────────────
class _DarkModeToggle extends StatelessWidget {
  const _DarkModeToggle({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: Row(
        children: [
          Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: itemColor,
            size: 22.sp,
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              'settings.dark_mode'.tr(),
              style: AppTextStyle.font14GreyMedium.copyWith(
                color: itemColor,
                fontSize: 15.sp,
                fontWeight: FontWeightHelper.medium,
              ),
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (_) {
              ThemeTransitionManager.show(context: context, isDark: !isDark);
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 22.sp),
            horizontalSpace(16),
            Text(
              label,
              style: AppTextStyle.font14GreyMedium.copyWith(
                color: itemColor,
                fontSize: 15.sp,
                fontWeight: FontWeightHelper.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.flag,
    required this.label,
    required this.locale,
  });

  final String flag;
  final String label;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = context.locale == locale;
    return InkWell(
      onTap: () {
        context.setLocale(locale);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.onSurface.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.onSurface
                : theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 20.sp)),
            horizontalSpace(12),
            Text(
              label,
              style: AppTextStyle.font14GreyMedium.copyWith(
                fontSize: 14.sp,
                fontWeight: isSelected
                    ? FontWeightHelper.semiBold
                    : FontWeightHelper.regular,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.onSurface,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}
