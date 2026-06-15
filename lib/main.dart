import 'package:calculator_project/src/models/repository/calculator_repository.dart';
import 'package:calculator_project/src/models/service/calculator_service.dart';
import 'package:calculator_project/src/viewmodel/calculator_view_model.dart';
import 'package:calculator_project/src/views/calculator_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CalculatorService>(create: (_) => CalculatorService()),
        Provider<CalculatorRepository>(
          create: (context) =>
              CalculatorRepository(context.read<CalculatorService>()),
        ),
        ChangeNotifierProvider<CalculatorViewModel>(
          create: (context) =>
              CalculatorViewModel(context.read<CalculatorRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const CalculatorView(),
      ),
    );
  }
}
