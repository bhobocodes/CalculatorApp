class CalculatorModel extends ChangeNotifier {
  CalculatorModel(required this._repository);
  final Repository repositroy;
  double result = 0;

  void add(double a , double b) {
    _repositroy.add(a,b);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void subtract(double a, double b){
    result = repository.subtract(a,b);
    notifyListeners();

  }

  void multiply (double a, double b){
    result = repository.multiply(a,b);
    notifyListeners();
  }

  void divide (double a, double b){
    result = repository.divide(a,b);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
