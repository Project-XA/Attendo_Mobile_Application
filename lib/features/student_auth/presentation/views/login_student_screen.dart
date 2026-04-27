import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_cubit.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_state.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_login_widgets/login_student_form_fields.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_login_widgets/login_student_footer.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_login_widgets/student_badge.dart';

class LoginStudentScreen extends StatefulWidget {
  const LoginStudentScreen({super.key});

  @override
  State<LoginStudentScreen> createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthStudentCubit>().login(
        LoginStudentRequestBody(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthStudentCubit, AuthStudentState>(
      listener: (context, state) {
        if (state.status == AuthStudentStatus.loginSuccess) {
          context.pushReplacmentNamed(Routes.studentNavigation);
        }
        if (state.status == AuthStudentStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? ''),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.mainBackgroundWhiteColor,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Attendo", style: AppTextStyle.font18BlackBold),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.mainBackgroundDarkColor,
              size: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'loginStudent.welcome_back'.tr(),
                  style: AppTextStyle.font24BlackBold,
                ),
                SizedBox(height: 8.h),
                Text(
                  'loginStudent.subtitle'.tr(),
                  style: AppTextStyle.font14GreyRegular,
                ),
                SizedBox(height: 20.h),
                const StudentBadge(),
                SizedBox(height: 36.h),
                LoginStudentFormFields(
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                SizedBox(height: 8.h),
                LoginStudentFooter(onLoginPressed: _onLoginPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
