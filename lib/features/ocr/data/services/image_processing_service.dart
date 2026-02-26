import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/*
This service provides utility functions for loading, resizing, and converting images to a format suitable for machine learning models.
It uses the 'image' package to handle image manipulation and supports normalization of pixel values
*/
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

// Converts an image to a Float32List suitable for model input, with optional normalization
// If normalize is true, pixel values will be scaled to the range [0, 1] by dividing by 255.0
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

// Main function to preprocess an image: load, resize, and convert to Float32List
// This function can be used to prepare images for input into machine learning models, with optional normalization of pixel values
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
