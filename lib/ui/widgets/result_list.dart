import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/calculator_bloc.dart';
import '../../bloc/calculator_event.dart';
import '../../bloc/calculator_state.dart';

class ResultListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Results'),
      ),
      body: BlocBuilder<CalculatorBloc, CalculatorState>(
        builder: (context, state) {
          if (state is CalculatorLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is RecentResultsLoadedState) {
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                return ListTile(
                  title: Text(
                    'Expression: ${result['expression']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    'Result: ${result['result']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  ),
                );
              },
            );
          }

          if (state is CalculatorErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          return Center(
            child: Text('No recent results found.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
