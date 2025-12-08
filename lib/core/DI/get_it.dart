import 'package:get_it/get_it.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';

final getIt = GetIt.instance;

void setup() {

  
   getIt.registerLazySingleton<CameraRepository>(() => CameraRepImp());
  
  // Use Cases
  getIt.registerLazySingleton(() => CapturePhotoUseCase(getIt()));
  getIt.registerLazySingleton(() => ValidateCardUseCase(getIt()));
  getIt.registerLazySingleton(() => ProcessCardUseCase(getIt()));
  
  // Cubit
  getIt.registerFactory(() => CameraCubit(
    getIt<CameraRepository>(),
    getIt<CapturePhotoUseCase>(),
    getIt<ValidateCardUseCase>(),
    getIt<ProcessCardUseCase>(),
  ));
}
