import 'package:flutter/material.dart';
import '../../bloc/calculator_state.dart';
import '../widgets/result_list.dart';

class ResultScreen extends StatelessWidget {
  final ExpressionCalculatedState state;

  ResultScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Expression: ${state.expression}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Result: ${state.result}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultListScreen(),
                  ),
                );
              },
              child: Text('Back to Input Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
