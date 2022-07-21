part of 'package:tum/provider/provider.dart';

class API with ChangeNotifier {
  String _htmlContent = "";
  String get htmlContent => _htmlContent;

  Object _error = "";
  Object get error => _error;

  bool _loading = false;
  bool get loading => _loading;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _success = false;
  bool get success => _success;

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

  List<Map<String, dynamic>> urls = [
    {"url": Urls.tumHome, "name": "Home"},
    {"url": Urls.tumNoticeBoard(1), "name": "NoticeBoard/Page_1"},
    {"url": Urls.tumNews(1), "name": "News/Page_1"},
  ];

  int i = 0;

  Future<void> getContent(String url) async {
    log('waiting for $url ...');
    try {
      while (i < urls.length) {
        final response = await http.get(Uri.parse(urls[i]['url']!));
        Map<String, Object?> map = {
          urls[i]['name'] ?? "Null": {"Content": response.body}
        };
        log('url:  ${urls[i]['url']}\nname:  ${urls[i]['name']}');
        if(response.ok){
          helper.updateToCustomPath(map);
        }

        i++;
      }
      // log('loading home web content');
      // final response = await http.get(Uri.parse(url));
      // Map<String, Object?> map = {
      //   "Home": {"Content": response.body}
      // };
      // helper.updateToCustomPath(map);
    } on SocketException {
      throw ("socket exception");
    } catch (e) {
      if (e is SocketException) {
        log('socket error: ' + e.toString());
      }
      log('an error occurred: ' + e.toString());
      _error = e;
    }

    _loading = false;
    notifyListeners();
  }

  Future<File> loadNetwork(String url) async {
    try {
      load();
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      return _storeFiles(url, bytes);
    } catch (exception) {
      _error = exception;
      _hasError = true;
      rethrow;
    }
  }

  Future<File> _storeFiles(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
