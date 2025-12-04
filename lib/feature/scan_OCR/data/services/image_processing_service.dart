import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessingService {
  static img.Image? loadImage(String imagePath) {
    try {
      final imageBytes = File(imagePath).readAsBytesSync();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        return null;
      }

      return image;
    } catch (e) {
      return null;
    }
  }

  static img.Image resizeImage(
    img.Image image, {
    required int width,
    required int height,
  }) {
    final resized = img.copyResize(image, width: width, height: height);
    return resized;
  }

  static Float32List imageToFloat32List(
    img.Image image, {
    bool normalize = true,
  }) {
    final width = image.width;
    final height = image.height;
    final inputBytes = Float32List(1 * height * width * 3);
    int pixelIndex = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final divisor = normalize ? 255.0 : 1.0;

        inputBytes[pixelIndex++] = pixel.r / divisor;
        inputBytes[pixelIndex++] = pixel.g / divisor;
        inputBytes[pixelIndex++] = pixel.b / divisor;
      }
    }

    return inputBytes;
  }

  static Float32List preprocessImage(
    String imagePath, {
    required int targetWidth,
    required int targetHeight,
    bool normalize = true,
  }) {
    final image = loadImage(imagePath);
    if (image == null) {
      throw Exception("Failed to load image");
    }

    final resized = resizeImage(
      image,
      width: targetWidth,
      height: targetHeight,
    );

    return imageToFloat32List(resized, normalize: normalize);
  }
}
