import 'package:flutter/cupertino.dart';
import '../models/calculation_histroy.dart';
import '../models/repository/calculator_repository.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorViewModel extends ChangeNotifier {
  CalculatorViewModel(this._repository);

  final CalculatorRepository _repository;

  double result = 0;

  final List<CalculationHistory> history = [];

  // ================= CLEAR RESULT =================
  void clear() {
    result = 0;
    notifyListeners();
  }

  // ================= MAIN CALCULATOR =================
  void calculateExpression(String expression) {
    try {
      Parser parser = Parser();

      Expression exp = parser.parse(
        expression.replaceAll('×', '*').replaceAll('÷', '/'),
      );

      ContextModel contextModel = ContextModel();

      result = exp.evaluate(EvaluationType.REAL, contextModel);

      history.add(CalculationHistory(expression: expression, result: result));

      notifyListeners();
    } catch (e) {
      result = 0;
      notifyListeners();
    }
  }

  // ================= HISTORY =================
  void clearHistory() {
    history.clear();
    notifyListeners();
  }

  void deleteHistory(int index) {
    history.removeAt(index);
    notifyListeners();
  }
}
