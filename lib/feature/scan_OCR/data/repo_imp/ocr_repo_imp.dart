
import 'dart:io';

import 'package:mobile_app/feature/scan_OCR/data/services/ocr_service.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/ocr_repo.dart';

class OcrRepoImpl implements OcrRepo {
  @override
  Future<String> extractTextToArabic(File imageFile) async {
    return await OcrService.extractText(
      imageFile: imageFile,
      language: 'ara',
      preprocessImage: true,
    );
  }

  @override
  Future<String> extractTextToEnglish(File imageFile) async {
    return await OcrService.extractText(
      imageFile: imageFile,
      language: 'eng',
      preprocessImage: true,
    );
  }

  @override
  Future<String> extractTextCombined(File imageFile) async {
    return await OcrService.extractText(
      imageFile: imageFile,
      language: 'ara+eng', // Combined language
      preprocessImage: true,
    );
  }
  @override
  Future<String> extractNumbers(File imageFile) async {
    return await OcrService.extractText(
      imageFile: imageFile,
      language: 'ara_number', // استخدام traineddata الخاص بالأرقام
      preprocessImage: true,
    );
  }
}