import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/student_auth/data/model/register_student_request_body.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_cubit.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_state.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/shared/app_button.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_register_widgets/register_fileds_page1.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_register_widgets/register_fileds_page2.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const RegisterForm({super.key, required this.formKey});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _pageController = PageController();
  final _page1Key = GlobalKey<FormState>();
  final _page2Key = GlobalKey<FormState>();
  int _currentPage = 0;

  // Controllers — one per field in RegisterStudentRequestBody
  final _organizationCodeController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _nextPage() {
    if (_page1Key.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage = 1);
    }
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = 0);
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _pageController.dispose();
    _organizationCodeController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _rollNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProgressIndicator(),
        verticalSpace(24),
        SizedBox(
          height: 500.h,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Form(
                key: _page1Key,
                child: RegisterFieldsPage1(
                  organizationCodeController: _organizationCodeController,
                  fullNameController: _fullNameController,
                  emailController: _emailController,
                  confirmEmailController: _confirmEmailController,
                ),
              ),
              Form(
                key: _page2Key,
                child: RegisterFieldsPage2(
                  rollNumberController: _rollNumberController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                ),
              ),
            ],
          ),
        ),
        _buildButtons(context),
      ],
    );
  }

  // ── Progress indicator ─────────────────────────────────────────────────────

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(2, (index) {
        final isActive = index <= _currentPage;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 4.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.mainBackgroundDarkColor
                  : AppColors.subTextGreyColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }

  // ── Action buttons ─────────────────────────────────────────────────────────

  Widget _buildButtons(BuildContext context) {
    if (_currentPage == 0) {
      return AppButton(
        buttonHeight: 56.h,
        onPressed: _nextPage,
        backgroundColor: AppColors.mainBackgroundDarkColor,
        radius: 16.r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'registerStudent.next_button'.tr(),
              style: TextStyle(
                color: AppColors.mainBackgroundWhiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeightHelper.semiBold,
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.mainBackgroundWhiteColor,
              size: 20,
            ),
          ],
        ),
      );
    }

    return BlocConsumer<AuthStudentCubit, AuthStudentState>(
      listener: (context, state) {
        if (state.status == AuthStudentStatus.registerSuccess) {
          context.pushNamed(Routes.mainNavigation);
        }
        if (state.status == AuthStudentStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? ''),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStudentStatus.loading;
        return Row(
          children: [
            // ── Back button ──────────────────────────────────────────────────
            OutlinedButton(
              onPressed: isLoading ? null : _prevPage,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(56.w, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                side: const BorderSide(
                  color: AppColors.mainBackgroundDarkColor,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.mainBackgroundDarkColor,
              ),
            ),
            SizedBox(width: 12.w),
            // ── Submit button ────────────────────────────────────────────────
            Expanded(
              child: AppButton(
                buttonHeight: 56.h,
                onPressed: isLoading ? null : _onSubmit,
                backgroundColor: AppColors.mainBackgroundDarkColor,
                radius: 16.r,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'registerStudent.sign_up_button'.tr(),
                        style: TextStyle(
                          color: AppColors.mainBackgroundWhiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeightHelper.semiBold,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Submit handler ─────────────────────────────────────────────────────────

  void _onSubmit() {
    if (!_page2Key.currentState!.validate()) return;

    context.read<AuthStudentCubit>().register(
      RegisterStudentRequestBody(
        organizationCode: int.parse(_organizationCodeController.text),
        fullname: _fullNameController.text,
        email: _emailController.text,
        confirmEmail: _confirmEmailController.text,
        rollNumber: _rollNumberController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }
}
