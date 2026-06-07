class CalculatorModel extends ChangeNotifier {
  CalculatorModel(required this._repository);
  final Repository _repositroy;
  void add(double a , double b) {
    _repositroy.add(a,b);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
