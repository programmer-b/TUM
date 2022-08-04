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

  List<String> _screenTitles = [];
  List<String> get screenTitles => _screenTitles;

  int _index = 0;
  int get index => _index;

  void updateScreenTitles(List<String> titles) {
    _screenTitles = titles;
    notifyListeners();
  }

  void updateScreenIndex(index) {
    _index = index;
    notifyListeners();
  }

  void navidateToScreen(context, String url, int index,
      {bool replace = false}) {
    _index = index;
    log('updating to index: $index');
    if (replace) {
      Navigator.pushNamedAndRemoveUntil(context, url, ModalRoute.withName('/'));
    } else {
      Navigator.pushNamedAndRemoveUntil(context, url, ModalRoute.withName('/'));
    }
    notifyListeners();
  }

  InAppWebViewController? _webViewController;
  InAppWebViewController? get webViewController => _webViewController;

  bool _browserIsLoading = false;
  bool get browserIsLoading => _browserIsLoading;

  bool _loadingError = false;
  bool get loadingError => _loadingError;

  void browserState() {}

  void setBrowserController(InAppWebViewController? controller) {
    _webViewController = controller;
    notifyListeners();
  }

  void browserInit() {
    _progress = 0;
    _loadingError = false;
    _browserIsLoading = false;
    _browserFinishedLoading = false;

    notifyListeners();
  }

  void onPageStarted() {
    _loadingError = false;
    _browserIsLoading = true;
    notifyListeners();
  }

  void onPageFinished() {
    _browserFinishedLoading = true;
    _browserIsLoading = false;
    notifyListeners();
  }

  void onPageLoadError() {
    _browserFinishedLoading = false;
    _loadingError = true;
    notifyListeners();
  }

  bool _sslError = false;
  bool get sslError => _sslError;

  bool _sslProceed = false;
  bool get sslProceed => _sslProceed;

  bool _browserFinishedLoading = false;
  bool get browserFinishedLoading => _browserFinishedLoading;

  void onReceivedSSLError({required bool proceed}) {
    _sslError = true;
    _sslProceed = proceed;
    notifyListeners();
  }

  double _progress = 0;
  double get progress => _progress;

  void onProgressChanged(int progress) {
    _progress = progress / 100;
    notifyListeners();
  }

  String _currentSearchItem = '';
  String get currentSearchItem => _currentSearchItem;

  void searchItem(String text) {
    _currentSearchItem = text;
    notifyListeners();
  }

  // int _newsIndex = 0;
  // int get newsIndex => _newsIndex;

  // void setNewsIndex(index) {
  //   _newsIndex = _newsIndex;
  //   notifyListeners();
  // }
}
