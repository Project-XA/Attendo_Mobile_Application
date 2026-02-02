import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/features/verification/data/models/face_detection_model.dart';
import 'package:mobile_app/features/verification/data/models/face_recognition_model.dart';
import 'package:mobile_app/features/verification/data/repo_impl/verify_repo_imp.dart';
import 'package:mobile_app/features/verification/domain/repo/verify_repo.dart';
import 'package:mobile_app/features/verification/domain/use_case/face_verify_use_case.dart';
import 'package:mobile_app/features/verification/domain/use_case/load_id_card_for_verification.dart';

void initVerifyScreen() {
  if (!getIt.isRegistered<FaceDetectionModel>()) {
    final faceDetectionModel = FaceDetectionModel();
    getIt.registerSingleton<FaceDetectionModel>(faceDetectionModel);
  }

  if (!getIt.isRegistered<FaceRecognitionModel>()) {
    final faceRecognitionModel = FaceRecognitionModel();
    getIt.registerSingleton<FaceRecognitionModel>(faceRecognitionModel);
  }

  if (!getIt.isRegistered<VerifyRepo>()) {
    getIt.registerLazySingleton<VerifyRepo>(
      () => VerifyRepoImp(
        userLocalDataSource: getIt<UserLocalDataSource>(),
        faceDetectionModel: getIt<FaceDetectionModel>(),
        faceReconitionModel: getIt<FaceRecognitionModel>(),
      ),
    );
  }

  if (!getIt.isRegistered<FaceVerifyUseCase>()) {
    getIt.registerLazySingleton<FaceVerifyUseCase>(
      () => FaceVerifyUseCase(verifyRepo: getIt<VerifyRepo>()),
    );
  }

  if (!getIt.isRegistered<LoadIdCardForVerification>()) {
    getIt.registerLazySingleton<LoadIdCardForVerification>(
      () => LoadIdCardForVerification(verifyRepo: getIt<VerifyRepo>()),
    );
  }
}
