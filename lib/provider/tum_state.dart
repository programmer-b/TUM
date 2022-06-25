part of 'package:tum/provider/provider.dart';

class TUMState with ChangeNotifier {
  int _currentScreen = 0;
  int get currentScreen => _currentScreen;

  void updateIndex(int index) {
    _currentScreen = index;
    notifyListeners();
  }
}
