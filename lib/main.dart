import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'bloc/calculator_bloc.dart';
import 'bloc/calculator_event.dart';
import 'bloc/calculator_state.dart';
import 'services/ocr_service.dart';
import 'services/storage_service.dart';
import 'ui/screens/input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Roll Calculator',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BlocProvider(
        create: (context) => CalculatorBloc(
          ocrService: OcrService(),
          storageService: StorageService(),
        ),
        child: InputScreen(),
      ),
    );
  }
}
