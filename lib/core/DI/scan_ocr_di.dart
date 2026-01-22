import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/features/ocr/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/captured_photo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_required_field_use_case.dart';
import 'package:mobile_app/features/ocr/presentation/logic/camera_cubit.dart';



void setupScanOcrFeature() {
  if (getIt.isRegistered<CameraCubit>()) return;

  getIt.registerLazySingleton<CameraRepository>(
    () => CameraRepImp(),
  );

  getIt.registerLazySingleton(
    () => CapturePhotoUseCase(getIt()),
  );

  getIt.registerLazySingleton(
    () => ValidateCardUseCase(getIt()),
  );

  if (!getIt.isRegistered<ValidateRequiredFieldsUseCase>()) {
    getIt.registerLazySingleton(() => ValidateRequiredFieldsUseCase());
  }
  getIt.registerLazySingleton(
    () => ProcessCardUseCase(getIt()),
  );

  getIt.registerLazySingleton(
    () => SaveScannedCardUseCase(getIt()),
  );


  getIt.registerFactory(
    () => CameraCubit(
      getIt(),
      getIt(),
      getIt(),
      getIt(),
      getIt(),
      getIt(),
    ),
  );
}
