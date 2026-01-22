import 'dart:io';

abstract class OcrRepo {
  Future<String> extractTextToArabic(File imageFile);
  Future<String> extractTextToEnglish(File imageFile);
  Future<String> extractTextCombined(File imageFile);
  Future<String> extractNumbers(File imageFile);
}