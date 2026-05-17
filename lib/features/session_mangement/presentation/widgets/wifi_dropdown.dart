import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class WifiDropdown extends StatefulWidget {
  final String? initialValue;
  final Function(String?) onChanged;

  const WifiDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<WifiDropdown> createState() => _WifiDropdownState();
}

class _WifiDropdownState extends State<WifiDropdown> {
  static const List<String> _options = ['WiFi'];
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ?? 'WiFi';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('sessions.connection_method_section'.tr(),
            style: AppTextStyle.font12GreyBold),
        verticalSpace(8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selected,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: AppTextStyle.font14BlackMedium,
              dropdownColor: colorScheme.surface,
              items: _options
                  .map((v) => DropdownMenuItem<String>(
                        value: v,
                        child: Text(v == 'WiFi'
                            ? 'sessions.connection_wifi'.tr()
                            : v),
                      ))
                  .toList(),
              onChanged: (option) {
                if (option != null && option != _selected) {
                  setState(() => _selected = option);
                  widget.onChanged(option);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}