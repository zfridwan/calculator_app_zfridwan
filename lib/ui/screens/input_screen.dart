import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/calculator_bloc.dart';
import '../../bloc/calculator_event.dart';
import '../../bloc/calculator_state.dart';

class InputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator Input'),
      ),
      body: BlocListener<CalculatorBloc, CalculatorState>(
        listener: (context, state) {
          if (state is CalculatorErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ExpressionCalculatedState) {
            Navigator.pushNamed(context, '/results', arguments: state);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<CalculatorBloc>(context)
                    .add(CaptureImageEvent());
              },
              child: Text('Capture Image'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<CalculatorBloc>(context).add(PickImageEvent());
              },
              child: Text('Pick Image from Gallery'),
            ),
            BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                if (state is ImagePickedState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      state.image,
                    ),
                  );
                }
                return Container();
              },
            ),
            BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (state is ImagePickedState) {
                      BlocProvider.of<CalculatorBloc>(context)
                          .add(CalculateExpressionEvent(state.image));
                    }
                  },
                  child: Text('Calculate Expression'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
