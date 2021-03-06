part of 'package:tum/provider/provider.dart';

class TUMState with ChangeNotifier {
  int _currentScreen = 0;
  int get currentScreen => _currentScreen;

  void updateIndex(int index) {
    _currentScreen = index;
    notifyListeners();
  }

  int _pages = 0;
  int _currentpage = 0;
  PDFViewController? _controller;
  bool _pdfReady = false;

  void pdfInit() {
    _pages = 0;
    _currentpage = 0;
    _pdfReady = false;
  }

  bool get pdfReady => _pdfReady;
  int get pages => _pages;
  int get indexPage => _currentpage;
  PDFViewController? get controller => _controller;

  void pagesFunc(int pages) {
    _pages = pages;
    _pdfReady = true;
    notifyListeners();
  }

  void indexPageFunc(int currentpage) {
    _currentpage = currentpage;
    notifyListeners();
  }

  void controllerFunc(PDFViewController? controller) {
    _controller = controller;
    notifyListeners();
  }
}
