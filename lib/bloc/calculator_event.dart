import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends CalculatorEvent {}

class CaptureImageEvent extends CalculatorEvent {}

class CalculateExpressionEvent extends CalculatorEvent {
  final File image;

  CalculateExpressionEvent(this.image);
}

class SwitchStorageEngineEvent extends CalculatorEvent {
  final bool isFileSystem;

  const SwitchStorageEngineEvent(this.isFileSystem);

  @override
  List<Object> get props => [isFileSystem];
}

class LoadRecentResultsEvent extends CalculatorEvent {}
