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
      print("\n" + "="*60);
      print("🔍 STEP 1: Checking if image is a card...");
      print("="*60);
      
      final photo = await _repo.capturePhoto();
      final isCard = await _repo.isCard(photo);
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (!isCard) {
        print("❌ Not a valid card. Stopping pipeline.");
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
      
      print("\n" + "="*60);
      print("🔍 STEP 2: Card detected! Now detecting fields...");
      print("="*60);
      
      final detections = await _repo.detectFields(photo);
      
      print("\n" + "="*60);
      print("✂️ STEP 3: Cropping detected fields...");
      print("="*60);
      
      final croppedFields = await _repo.cropDetectedFields(photo, detections);
      
      print("\n" + "="*60);
      print("✅ PIPELINE COMPLETE - ${croppedFields.length} fields cropped");
      print("="*60 + "\n");
      
      emit(
        state.copyWith(
          photo: photo,
          hasCaptured: true,
          isProcessing: false,
          showResult: true,
          croppedFields: croppedFields, // ✅ حفظ الـ cropped fields
        ),
      );
    } catch (e) {
      print("❌ Error in pipeline: $e");
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
    emit(state.copyWith(
      photo: null,
      hasCaptured: false,
      showResult: false,
      croppedFields: null, 
    ));
  }

  @override
  Future<void> close() {
    if ((_repo as dynamic).close != null) {
      (_repo as dynamic).close();
    }
    return super.close();
  }
}