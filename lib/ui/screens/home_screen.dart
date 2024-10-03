import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/calculator_bloc.dart';
import '../../bloc/calculator_event.dart';
import '../../bloc/calculator_state.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Result Calculator'),
      ),
      body: BlocConsumer<CalculatorBloc, CalculatorState>(
        listener: (context, state) {
          if (state is CalculatorErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ExpressionCalculatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Result: ${state.result}')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CalculatorBloc>(context)
                        .add(CaptureImageEvent());
                  },
                  child: Text('Capture Image from Camera'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CalculatorBloc>(context)
                        .add(PickImageEvent());
                  },
                  child: Text('Pick Image from Gallery'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CalculatorBloc>(context)
                        .add(LoadRecentResultsEvent());
                  },
                  child: Text('Show Recent Results'),
                ),
                SizedBox(height: 20),
                // Switch storage engine
                SwitchListTile(
                  title: Text('Use File System Storage'),
                  value: context.read<CalculatorBloc>().isFileSystem,
                  onChanged: (value) {
                    BlocProvider.of<CalculatorBloc>(context)
                        .add(SwitchStorageEngineEvent(value));
                  },
                ),

                if (state is CalculatorLoadingState)
                  CircularProgressIndicator(),

                if (state is RecentResultsLoadedState)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final result = state.results[index];
                        final expression = result['expression'];
                        final calculatedResult = result['result'];

                        return ListTile(
                          title: Text('$expression = $calculatedResult'),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
