import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/onboarding/widgets/step_item.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth > 600;
            bool isLargeScreen = constraints.maxWidth > 900;

            double logoSize = isLargeScreen
                ? constraints.maxWidth * 0.45
                : isTablet
                ? constraints.maxWidth * 0.6
                : constraints.maxWidth * 1;

            double textFont = isTablet ? 20 : 18;
            double descFont = isTablet ? 16 : 14;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48.0 : 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpace(size.height * 0.05),

                    Image.asset(
                      Assets.assetsImagesAttendoLogo,
                      width: logoSize,
                    ),

                    verticalSpace(15),

                    Text(
                      'onboarding.welcome_title'.tr(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: textFont.sp,
                        fontWeight: FontWeightHelper.bold,
                      ),
                    ),

                    verticalSpace(8),

                    Text(
                      'onboarding.welcome_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: descFont.sp,
                        fontWeight: FontWeightHelper.medium,
                      ),
                    ),

                    verticalSpace(30),

                    /// STEPS
                    Column(
                      children: [
                        StepItem(
                          icon: Icons.phone_android,
                          title: 'onboarding.step_device_title'.tr(),
                          subtitle: 'onboarding.step_device_subtitle'.tr(),
                        ),
                        StepItem(
                          icon: Icons.apartment,
                          title: 'onboarding.step_org_title'.tr(),
                          subtitle: 'onboarding.step_org_subtitle'.tr(),
                        ),
                        StepItem(
                          icon: Icons.location_pin,
                          title: 'onboarding.step_attendance_title'.tr(),
                          subtitle: 'onboarding.step_attendance_subtitle'.tr(),
                        ),
                      ],
                    ),

                    verticalSpace(size.height * 0.07),

                    /// BUTTON
                    CustomAppButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        'onboarding.start_registration'.tr(),
                        style: AppTextStyle.font15WhiteBold.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(Routes.scanIdScreen);
                      },
                    ),

                    CustomAppButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        'onboarding.start_registration'.tr(),
                        style: AppTextStyle.font15WhiteBold.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(Routes.studentLoginScreen);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
