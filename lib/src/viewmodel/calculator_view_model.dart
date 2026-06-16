import 'package:flutter/cupertino.dart';
import '../models/calculation_histroy.dart';
import '../models/repository/calculator_repository.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorViewModel extends ChangeNotifier {
  CalculatorViewModel(this._repository);

  final CalculatorRepository _repository;

  String result = "0";

  final List<CalculationHistory> history = [];

  bool _endsWithOperator(String expression) {
    return expression.endsWith('+') ||
        expression.endsWith('-') ||
        expression.endsWith('*') ||
        expression.endsWith('/') ||
        expression.endsWith('×') ||
        expression.endsWith('÷');
  }



  // ================= CLEAR RESULT =================
  void clear() {
    result = "0";
    notifyListeners();
  }

  // ================= MAIN CALCULATOR =================
  void calculateExpression(String expression) {
    expression = expression.trim();

    if (expression.isEmpty) {
      result = "Empty Expression";
      notifyListeners();
      return;
    }

    if (_endsWithOperator(expression)) {
      result = "Invalid Expression";
      notifyListeners();
      return;
    }

    try {
      Parser parser = Parser();

      Expression exp = parser.parse(
        expression.replaceAll('×', '*').replaceAll('÷', '/'),
      );

      ContextModel contextModel = ContextModel();

      double value = exp.evaluate(
        EvaluationType.REAL,
        contextModel,
      );

      result = value.toString();

      notifyListeners();
    } catch (e) {
      result = "Invalid";
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
