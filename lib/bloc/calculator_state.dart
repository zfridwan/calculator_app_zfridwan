import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorInitialState extends CalculatorState {}

class CalculatorLoadingState extends CalculatorState {}

class ImagePickedState extends CalculatorState {
  final File image;

  ImagePickedState(this.image);
}

class ExpressionCalculatedState extends CalculatorState {
  final String expression;
  final double result;

  const ExpressionCalculatedState(
      {required this.expression, required this.result});

  @override
  List<Object> get props => [expression, result];
}

class CalculatorErrorState extends CalculatorState {
  final String message;

  const CalculatorErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class StorageEngineSwitchedState extends CalculatorState {
  final bool isFileSystem;

  const StorageEngineSwitchedState(this.isFileSystem);

  @override
  List<Object> get props => [isFileSystem];
}

class RecentResultsLoadedState extends CalculatorState {
  final List<Map<String, dynamic>> results;

  RecentResultsLoadedState(this.results);
}
