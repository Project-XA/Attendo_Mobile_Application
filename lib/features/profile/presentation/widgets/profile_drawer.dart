import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/profile/presentation/widgets/dark_mode_toggle.dart';
import 'package:mobile_app/features/profile/presentation/widgets/drawer_item.dart';
import 'package:mobile_app/features/profile/presentation/widgets/language_tile.dart';

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

            DrawerItem(
              icon: Icons.language_rounded,
              label: 'settings.language'.tr(),
              onTap: () => _showLanguageDialog(context),
            ),

            verticalSpace(8),

            DarkModeToggle(isDark: isDark),

            DrawerItem(
              icon: Icons.security_rounded,
              label: 'settings.privacy'.tr(),
              onTap: () {
                context.pushNamed(Routes.privacyAndSecurityScreen);
              },
            ),
            const Spacer(),

            Divider(color: theme.dividerTheme.color),
            verticalSpace(12),

            DrawerItem(
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
            LanguageTile(
              flag: '🇺🇸',
              label: 'settings.language_english'.tr(),
              locale: const Locale('en'),
            ),
            verticalSpace(8),
            LanguageTile(
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
