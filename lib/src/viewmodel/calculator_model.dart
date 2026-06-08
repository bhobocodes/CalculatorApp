
import 'package:flutter/cupertino.dart';
import '../models/service/calculator_service.dart';

class CalculatorViewModel extends ChangeNotifier {
  CalculatorViewModel(this._repository);

  final CalculatorService _repository;

  double result = 0;

  void add(double a , double b) {
  result = _repository.add(a,b);
  // This call tells the widgets that are listening to this model to rebuild.
  notifyListeners();
  }

  void subtract(double a, double b){
  result = _repository.subtract(a,b);
  notifyListeners();

  }

  void multiply (double a, double b){
  result = _repository.multiply(a,b);
  notifyListeners();
  }

  void divide (double a, double b){
  result = _repository.divide(a,b);
  notifyListeners();
    }
  }
  /// Removes all items from the cart.
