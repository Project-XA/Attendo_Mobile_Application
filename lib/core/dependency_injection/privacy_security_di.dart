import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/privacy_and_security/data/data_source/ps_remote_data_source.dart';
import 'package:mobile_app/features/privacy_and_security/data/repo_impl/privacy_security_repo_impl.dart';
import 'package:mobile_app/features/privacy_and_security/domain/repo/privacy_security_repo.dart';
import 'package:mobile_app/features/privacy_and_security/domain/use_cases/change_password_use_case.dart';
import 'package:mobile_app/features/privacy_and_security/domain/use_cases/deactive_account_use_case.dart';
import 'package:mobile_app/features/privacy_and_security/domain/use_cases/delete_acccount_use_case.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/logic/privacy_and_security_cubit.dart';

void privacySecurityDi() {
  if (getIt.isRegistered<PrivacySecurityCubit>()) return;
  registerLazyIfNotRegistered<PsRemoteDataSource>(
    () => PsRemoteDataSourceImpl(networkService: getIt()),
  );
  registerLazyIfNotRegistered<PrivacySecurityRepo>(
    () => PrivacySecurityRepoImpl(
      psRemoteDataSource: getIt<PsRemoteDataSource>(),
    ),
  );

  registerLazyIfNotRegistered<DeleteAccountUseCase>(
    () =>
        DeleteAccountUseCase(privacySecurityRepo: getIt<PrivacySecurityRepo>()),
  );
  registerLazyIfNotRegistered<DeactivateAccountUseCase>(
    () => DeactivateAccountUseCase(getIt<PrivacySecurityRepo>()),
  );

  registerLazyIfNotRegistered<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(
      privacySecurityRepo: getIt<PrivacySecurityRepo>(),
    ),
  );

  registerLazyIfNotRegistered<PrivacySecurityCubit>(
    () => PrivacySecurityCubit(
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      deactivateAccountUseCase: getIt<DeactivateAccountUseCase>(),
      deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
    ),
  );
}
