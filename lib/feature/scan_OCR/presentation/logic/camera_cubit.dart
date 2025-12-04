import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository _repo;

  CameraCubit(this._repo) : super(CameraState());

  CameraController? get controller => state.controller;

  Future<void> openCamera() async {
    emit(state.copyWith(isInitializing: true));

    try {
      await _repo.openCamera();

      emit(
        state.copyWith(
          isOpened: true,
          isInitializing: false,
          controller: (_repo as dynamic).controller,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isInitializing: false, isOpened: false));
    }
  }

  Future<void> capturePhoto() async {
    emit(state.copyWith(isProcessing: true));

    try {
      final photo = await _repo.capturePhoto();

     
      final isCard = await _repo.isCard(photo);

      await Future.delayed(const Duration(seconds: 1));

      if (!isCard) {
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasCaptured: true,
            photo: photo,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          photo: photo,
          hasCaptured: true,
          isProcessing: false,
          showResult: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isProcessing: false,
          showResult: false,
          hasCaptured: false,
        ),
      );
    }
  }

  void retakePhoto() {
    emit(state.copyWith(photo: null, hasCaptured: false, showResult: false));
  }

  @override
  Future<void> close() {
    if ((_repo as dynamic).close != null) {
      (_repo as dynamic).close();
    }
    return super.close();
  }
}
