import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/services/permission/camera_permission_service.dart';
import 'package:mobile_app/features/ocr/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/features/verification/data/exceptions/face_recognition_exception.dart';
import 'package:mobile_app/features/verification/data/exceptions/no_face_detected_exception.dart';
import 'package:mobile_app/features/verification/data/models/face_detection_model.dart';
import 'package:mobile_app/features/verification/data/models/face_recognition_model.dart';
import 'package:mobile_app/features/verification/data/service/face_detection_service.dart';
import 'package:mobile_app/features/verification/data/service/face_recognition_service.dart';
import 'package:mobile_app/features/verification/domain/entities/face_detection_result.dart';
import 'package:mobile_app/features/verification/domain/repo/verify_repo.dart';

class VerifyRepoImp extends VerifyRepo {
  final CameraPermissionService _permissionService;
  final UserLocalDataSource userLocalDataSource;
  final FaceDetectionModel _faceDetectionModel;
  final FaceRecognitionModel _faceRecognitionModel;

  CameraController? _controller;
  bool _isCameraInitialized = false;

  VerifyRepoImp({
    CameraPermissionService? permissionService,
    required this.userLocalDataSource,
    required FaceDetectionModel faceDetectionModel,
    required FaceRecognitionModel faceReconitionModel,
  }) : _permissionService = permissionService ?? CameraPermissionService(),
       _faceDetectionModel = faceDetectionModel,
       _faceRecognitionModel = faceReconitionModel;

  @override
  CameraController? get controller => _controller;

  @override
  bool get isCameraInitialized => _isCameraInitialized;

  @override
  Future<void> openCamera() async {
    final hasPermission = await _permissionService.isCameraPermissionGranted();

    if (!hasPermission) {
      final granted = await _permissionService.requestCameraPermission();

      if (!granted) {
        throw CameraPermissionException(
          'Camera permission is required to scan ID cards.',
        );
      }
    }

    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      throw Exception('No cameras available on this device');
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isCameraInitialized = true;

    await _faceDetectionModel.loadModel();
    await _faceRecognitionModel.loadModel();
  }

  @override
  Future<void> closeCamera() async {
    await _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;
  }

  @override
  Future<String> capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera is not initialized');
    }

    final XFile file = await _controller!.takePicture();

    return file.path;
  }

  @override
  Future<bool> faceDetection({
    required String imagePath,
    bool isIdCardImage = false,
  }) async {
    try {
      if (!_faceDetectionModel.isLoaded) {
        await _faceDetectionModel.loadModel();

        if (!_faceDetectionModel.isLoaded) {
          throw Exception(
            'Face detection model failed to load. Please try again.',
          );
        }
      }

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image. Please try again.');
      }

      final bool actualIsIdCard =
          isIdCardImage || (image.width < 200 || image.height < 200);

      final result = await FaceDetectionService.detectFace(
        imagePath: imagePath,
        interpreterAddress: _faceDetectionModel.interpreterAddress,
        isIdCardImage: actualIsIdCard,
      );

      final double minConfidence = actualIsIdCard ? 0.5 : 0.6;

      if (result.confidence < minConfidence) {
        throw LowConfidenceException(
          'Face detection confidence is too low (${(result.confidence * 100).toStringAsFixed(1)}%). '
          'Please improve lighting and try again.',
        );
      }

      return true;
    } on NoFaceDetectedException {
      rethrow;
    } on MultipleFacesDetectedException {
      rethrow;
    } on LowConfidenceException {
      rethrow;
    } catch (e) {
      throw FaceDetectionException('Face detection failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> verifyIdentity({
    required String idCardImagePath,
    required String selfieImagePath,
  }) async {
    try {
      await faceDetection(imagePath: idCardImagePath, isIdCardImage: true);
      final idCardDetection = await _getDetectionResult(
        idCardImagePath,
        isIdCardImage: true,
      );

      await faceDetection(imagePath: selfieImagePath, isIdCardImage: false);
      final selfieDetection = await _getDetectionResult(
        selfieImagePath,
        isIdCardImage: false,
      );

      if (!_faceRecognitionModel.isLoaded) {
        await _faceRecognitionModel.loadModel();
      }

      final isMatch = await FaceRecognitionService.verifyFaces(
        image1Path: idCardImagePath,
        image2Path: selfieImagePath,
        interpreterAddress: _faceRecognitionModel.interpreterAddress,
        face1Detection: idCardDetection,
        face2Detection: selfieDetection,
      );

      return isMatch;
    } on NoFaceDetectedException {
      rethrow;
    } on MultipleFacesDetectedException {
      rethrow;
    } on LowConfidenceException {
      rethrow;
    } on FaceNotMatchedException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getIdCardImagePath() async {
    try {
      final path = await userLocalDataSource.getIdCardImagePath();

      if (path.isEmpty) {
        throw Exception(
          'ID card image path is empty. Please scan your ID card first.',
        );
      }

      if (path.length < 5 || !path.contains('/')) {
        throw Exception(
          'Invalid ID card image path: "$path". Please scan your ID card again.',
        );
      }

      final file = File(path);
      final exists = await file.exists();

      if (!exists) {
        throw Exception(
          'ID card image file does not exist at: $path. '
          'Please scan your ID card again.',
        );
      }

      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception(
          'Cannot decode ID card image. The file may be corrupted. '
          'Please scan your ID card again.',
        );
      }

      return path;
    } catch (e) {
      rethrow;
    }
  }

  Future<FaceDetectionResult> _getDetectionResult(
    String imagePath, {
    required bool isIdCardImage,
  }) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    return await FaceDetectionService.detectFace(
      imagePath: imagePath,
      interpreterAddress: _faceDetectionModel.interpreterAddress,
      isIdCardImage: isIdCardImage,
    );
  }
}
