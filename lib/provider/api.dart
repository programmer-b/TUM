part of 'package:tum/provider/provider.dart';

class API with ChangeNotifier {
  String _htmlContent = "";
  String get htmlContent => _htmlContent;

  Object _error = "";
  Object get error => _error;

  bool _loading = false;
  bool get loading => _loading;

  void init() {
    _htmlContent = "";
    _loading = false;
    notifyListeners();
  }

  void load() {
    log("loading");
    _loading = true;
    notifyListeners();
  }

  Future<void> getContent(String url) async {
    try {
      //_load();
      final response = await http.get(Uri.parse(url));
      _htmlContent = response.body.toString();
    } catch (e) {
      _error = e;
    }

    _loading = false;
    notifyListeners();
  }
}
