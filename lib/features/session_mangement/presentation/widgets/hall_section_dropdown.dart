import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';

class HallSectionDropdown extends StatefulWidget {
  final bool isUniversity;
  final int? selectedId;
  final Function(int?, String?)? onSelected;
  final VoidCallback? onRefresh;

  const HallSectionDropdown({
    super.key,
    required this.isUniversity,
    this.selectedId,
    this.onSelected,
    this.onRefresh,
  });

  @override
  State<HallSectionDropdown> createState() => _HallSectionDropdownState();
}

class _HallSectionDropdownState extends State<HallSectionDropdown> {
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  void didUpdateWidget(HallSectionDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != oldWidget.selectedId) {
      setState(() => _selectedId = widget.selectedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SessionManagementCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.isUniversity) {
      final isLoading = state is SessionManagementIdle && state.isLoadingSections;
      final hasError = state is SessionError;
      final sections = state is SessionManagementIdle ? state.sections : null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('sessions.org_section_section'.tr(),
              style: AppTextStyle.font12GreyBold),
          verticalSpace(8.h),
          if (isLoading)
            _LoadingState()
          else if (hasError || sections == null)
            _ErrorState(onRefresh: widget.onRefresh)
          else if (sections.isEmpty)
            _EmptyState(
              message: 'sessions.no_sections'.tr(),
              onRefresh: widget.onRefresh,
            )
          else
            _DropdownField<int>(
              selectedId: _selectedId,
              items: sections
                  .map((s) => _DropdownItem(id: s.id, label: s.sectionName))
                  .toList(),
              hint: 'sessions.select_section_hint'.tr(),
              onChanged: (id) {
                if (id != null) {
                  setState(() => _selectedId = id);
                  final name = sections.firstWhere((s) => s.id == id).sectionName;
                  widget.onSelected?.call(id, name);
                }
              },
            ),
        ],
      );
    }

    // ── Halls ──
    final isLoading = state is SessionManagementIdle && state.isLoadingHalls;
    final hasError = state is SessionError;
    final halls = state is SessionManagementIdle ? state.halls : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('sessions.org_hall_section'.tr(),
            style: AppTextStyle.font12GreyBold),
        verticalSpace(8.h),
        if (isLoading)
          _LoadingState()
        else if (hasError || halls == null)
          _ErrorState(onRefresh: widget.onRefresh)
        else if (halls.isEmpty)
          _EmptyState(
            message: 'sessions.no_halls'.tr(),
            onRefresh: widget.onRefresh,
          )
        else
          _DropdownField<int>(
            selectedId: _selectedId,
            items: halls
                .map((h) => _DropdownItem(id: h.id, label: h.hallName))
                .toList(),
            hint: 'sessions.select_hall_hint'.tr(),
            onChanged: (id) {
              if (id != null) {
                setState(() => _selectedId = id);
                final name = halls.firstWhere((h) => h.id == id).hallName;
                widget.onSelected?.call(id, name);
              }
            },
          ),
      ],
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text('sessions.loading_halls'.tr(),
              style: AppTextStyle.font13Grey600Medium),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback? onRefresh;
  const _ErrorState({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.red.shade50,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text('sessions.failed_load_halls'.tr(),
                style: AppTextStyle.font13Red700Medium),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(Icons.refresh, color: Colors.red, size: 20.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'common.retry'.tr(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;
  const _EmptyState({required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.orange.shade50,
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(message, style: AppTextStyle.font13Orange700Medium),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(Icons.refresh, color: Colors.orange, size: 20.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'common.retry'.tr(),
          ),
        ],
      ),
    );
  }
}

class _DropdownItem {
  final int id;
  final String label;
  const _DropdownItem({required this.id, required this.label});
}

class _DropdownField<T> extends StatelessWidget {
  final int? selectedId;
  final List<_DropdownItem> items;
  final String hint;
  final ValueChanged<int?> onChanged;

  const _DropdownField({
    required this.selectedId,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(20.r),
        color: colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedId,
          isExpanded: true,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down),
          style: AppTextStyle.font14BlackMedium,
          focusColor: colorScheme.surface,
          dropdownColor: colorScheme.surface,
          items: items
              .map((item) => DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(item.label),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}