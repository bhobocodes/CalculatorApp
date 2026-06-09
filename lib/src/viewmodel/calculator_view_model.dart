import 'package:flutter/cupertino.dart';
import '../models/calculation_histroy.dart';
import '../models/repository/calculator_repository.dart';


class CalculatorViewModel extends ChangeNotifier {
  CalculatorViewModel(this._repository);

  final CalculatorRepository _repository;

  double result = 0;

  // ✅ HISTORY ADD
  final List<CalculationHistory> history = [];

  void clear() {
    result = 0;
    notifyListeners();
  }

  void add(double a, double b) {
    result = _repository.add(a, b);

    // ✅ save history
    history.add(
      CalculationHistory(
        expression: "$a + $b",
        result: result,
      ),
    );

    notifyListeners();
  }

  void subtract(double a, double b) {
    result = _repository.subtract(a, b);

    history.add(
      CalculationHistory(
        expression: "$a - $b",
        result: result,
      ),
    );

    notifyListeners();
  }

  void multiply(double a, double b) {
    result = _repository.multiply(a, b);

    history.add(
      CalculationHistory(
        expression: "$a × $b",
        result: result,
      ),
    );

    notifyListeners();
  }

  void divide(double a, double b) {
    if (b == 0) {
      result = 0;
      return;
    }

    result = _repository.divide(a, b);

    history.add(
      CalculationHistory(
        expression: "$a ÷ $b",
        result: result,
      ),
    );

    notifyListeners();
  }

  // ✅ optional: clear history
  void clearHistory() {
    history.clear();
    notifyListeners();
  }

  void deleteHistory(int index) {
    history.removeAt(index);
    notifyListeners();
  }
}