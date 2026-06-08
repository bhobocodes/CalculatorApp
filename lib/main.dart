import 'package:calculator_project/src/models/service/calculator_service.dart';
import 'package:calculator_project/src/viewmodel/calculator_model.dart';
import 'package:calculator_project/src/views/calculator_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorService = CalculatorService();

    final calculatorViewModel = CalculatorViewModel(
      calculatorService,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      home: CalculatorView(
        viewModel: calculatorViewModel,
      ),
    );
  }
}