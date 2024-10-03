import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../services/ocr_service.dart';
import '../services/storage_service.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final OcrService _ocrService;
  final StorageService _storageService;

  bool _isFileSystem = false;

  bool get isFileSystem => _isFileSystem;

  CalculatorBloc({
    required OcrService ocrService,
    required StorageService storageService,
  })  : _ocrService = ocrService,
        _storageService = storageService,
        super(CalculatorInitialState());

  @override
  Stream<CalculatorState> mapEventToState(CalculatorEvent event) async* {
    if (event is PickImageEvent || event is CaptureImageEvent) {
      yield CalculatorLoadingState();

      final image = event is PickImageEvent
          ? await _ocrService.pickImageFromGallery()
          : await _ocrService.captureImageFromCamera();

      if (image is File) {
        yield ImagePickedState(image);
      } else {
        yield CalculatorErrorState("The picked image is not a valid file.");
      }
    }

    if (event is CalculateExpressionEvent) {
      yield CalculatorLoadingState();

      try {
        final expression =
            await _ocrService.detectExpressionFromImage(event.image);
        if (expression.isEmpty) {
          yield CalculatorErrorState(
              "No valid arithmetic expression found in the image.");
          return;
        }

        final result = _calculateExpression(expression);
        await _storageService.storeResult(expression, result);
        yield ExpressionCalculatedState(expression: expression, result: result);
      } catch (e) {
        yield CalculatorErrorState(
            "Failed to calculate expression: ${e.toString()}");
      }
    }

    if (event is SwitchStorageEngineEvent) {
      _isFileSystem = event.isFileSystem;
      _storageService.switchEngine(event.isFileSystem);
      yield StorageEngineSwitchedState(event.isFileSystem);
    }

    if (event is LoadRecentResultsEvent) {
      yield CalculatorLoadingState();
      try {
        final results = await _storageService.loadRecentResults();
        yield RecentResultsLoadedState(results);
      } catch (e) {
        yield CalculatorErrorState("Failed to load recent results.");
      }
    }
  }

  double _calculateExpression(String expression) {
    final sanitizedExpression = expression.replaceAll(' ', '');
    try {
      if (sanitizedExpression.contains('+')) {
        final parts = sanitizedExpression.split('+');
        return double.parse(parts[0]) + double.parse(parts[1]);
      } else if (sanitizedExpression.contains('-')) {
        final parts = sanitizedExpression.split('-');
        return double.parse(parts[0]) - double.parse(parts[1]);
      } else if (sanitizedExpression.contains('*')) {
        final parts = sanitizedExpression.split('*');
        return double.parse(parts[0]) * double.parse(parts[1]);
      } else if (sanitizedExpression.contains('/')) {
        final parts = sanitizedExpression.split('/');
        return double.parse(parts[0]) / double.parse(parts[1]);
      }
      throw FormatException("Unsupported operation or malformed expression");
    } catch (e) {
      print("Error calculating expression: $e");
      throw FormatException("Failed to calculate expression: ${e.toString()}");
    }
  }
}
