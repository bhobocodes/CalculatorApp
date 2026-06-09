
import '../service/calculator_service.dart';

class CalculatorRepository {
  final CalculatorService _service;

  CalculatorRepository(this._service);

  double add(double a, double b) {
    return _service.add(a, b);
  }

  double subtract(double a, double b) {
    return _service.subtract(a, b);
  }

  double multiply(double a, double b) {
    return _service.multiply(a, b);
  }

  double divide(double a, double b) {
    return _service.divide(a, b);
  }
}