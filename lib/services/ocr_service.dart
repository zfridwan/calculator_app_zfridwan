import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class OcrService {
  final ImagePicker _picker = ImagePicker();

  Future<File> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
  }

  Future<File> captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return File(pickedFile!.path);
  }

  Future<String> detectExpressionFromImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);

      final textDetector = GoogleMlKit.vision.textRecognizer();

      final RecognizedText recognizedText =
          await textDetector.processImage(inputImage);

      await textDetector.close();

      return _extractFirstArithmeticExpression(recognizedText.text);
    } catch (e) {
      throw Exception('Failed to detect expression from the image: $e');
    }
  }

  String _extractFirstArithmeticExpression(String detectedText) {
    final arithmeticRegex = RegExp(r'(\d+\s*[\+\-\*\/]\s*\d+)');
    final match = arithmeticRegex.firstMatch(detectedText);
    if (match != null) {
      return match.group(0)!.trim();
    } else {
      throw Exception('No valid arithmetic expression found.');
    }
  }
}
