import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class StudentAuthHeader extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;

  const StudentAuthHeader({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(),
          style: AppTextStyle.font24BlackBold,
        ),
        verticalSpace(8),
        Text(
          subtitleKey.tr(),
          style: AppTextStyle.font14GreyRegular,
        ),
      ],
    );
  }
}