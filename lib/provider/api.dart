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

  String _progress = "0";
  String get progress => _progress;

  void init() {
    _success = false;
    _hasError = false;
    _htmlContent = "";
    _loading = false;
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
    {"url": Urls.tumDownloads(1), "name": "Downloads/Page_1"},
  ];

  int i = 0;

  Future<void> getHtml(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.ok) {
        _success = true;
        _htmlContent = response.body;
      }
      _error = true;
    } on SocketException {
      _error = true;
      throw ("socket exception");
    } catch (e) {
      _error = true;
      if (e is SocketException) {
        log('socket error: $e');
      }
      log('an error occurred: $e');
      _error = e;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> getContent(String url) async {
    log('waiting for $url ...');
    try {
      while (i < urls.length) {
        final response = await http.get(Uri.parse(urls[i]['url']!));
        Map<String, Object?> map = {
          urls[i]['name'] ?? "Null": {"Content": response.body}
        };
        log('url:  ${urls[i]['url']}\nname:  ${urls[i]['name']}');
        if (response.ok) {
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
        log('socket error: $e');
      }
      log('an error occurred: $e');
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

  Future startDownload(String savePath, String url, String fileName) async {
    Map<String, dynamic> result = {
      "isSuccess": false,
      "filePath": null,
      "fileName": fileName,
      "error": null
    };
    final Dio dio = Dio();
    try {
      final response = await dio.download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            _progress = "${(count / total * 100).toStringAsFixed(0)}%";
            notifyListeners();
          }
        },
      );

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;

      if (response.statusCode == 200) {
        _success = true;
      }
    } catch (e) {
      _hasError = true;
      log("$e");
      result['error'] = e.toString();
    } finally {
      await notify.showDownloadNotification(result);
    }
    notifyListeners();
  }

  bool _downloading = false;
  bool get downloading => _downloading;

  Future download(String url, String fileName) async {
    _downloading = true;
    final dir = await storage.getDownloadsDirectory();
    if (await requestPermission(Permission.storage) && await requestPermission(Permission.manageExternalStorage)) {
      final savePath = path.join(dir!.path, fileName);
      await startDownload(savePath, url, fileName);
    } else {
      messenger
          .showToast('Please give permission in order to download the file');
    }
    _downloading = false;
    notifyListeners();
  }
}

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
