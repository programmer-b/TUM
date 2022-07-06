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

  List<Map<String, String>> urls = [
    {"url": Urls.tumHome, "name": "Home"},
    {"url": Urls.tumNoticeBoard, "name": "NoticeBoard"}
  ];

  int i = 0;

  Future<void> getContent(String url) async {
    try {
      while (i < urls.length) {
        final response = await http.get(Uri.parse(urls[i]['url']!));
        Map<String, Object?> map = {
          urls[i]['name'] ?? "Null": {"Content": response.body}
        };
        log('url:  ${urls[i]['url']}\nname:  ${urls[i]['name']}');
        helper.updateToCustomPath(map);

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
}
