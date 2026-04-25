import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/auth/presentation/logic/auth_cubit.dart';
import 'package:mobile_app/features/auth/presentation/logic/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/register_form_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/register_submit_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _orgIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _orgIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final localDataSource = getIt<UserLocalDataSource>();
        final localUserData = await localDataSource.getCurrentUser();

        if (!mounted) return;

        await context.read<AuthCubit>().register(
          orgId: _orgIdController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          localUserData: localUserData,
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('failed_to_get_user_data'.tr(args: [e.toString()])),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleSuccess(AuthState state) {
    if (!mounted) return;

    final userRole = state.user?.organizations?.first.role ?? 'User';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('registered_successfully'.tr(args: [userRole])),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.pushReplacmentNamed(Routes.mainNavigation, arguments: userRole);
    });
  }

  void _handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.registerSuccess) {
          _handleSuccess(state);
        } else if (state.status == AuthStatus.failure) {
          _handleError(state.error?.message ?? '');
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterFormFields(
                orgIdController: _orgIdController,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              verticalSpace(20.h),
              RegisterSubmitButton(
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        );
      },
    );
  }
}
