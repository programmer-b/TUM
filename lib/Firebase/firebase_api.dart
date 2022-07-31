part of 'package:tum/Firebase/firebase.dart';

class FirebaseApi with ChangeNotifier {
  bool _uploading = false;
  bool get uploading => _uploading;

  _upload() {
    _uploading = true;
    notifyListeners();
  }

  void init() {
    _uploading = false;
    notifyListeners();
  }

  UploadTask? uploadFile(String destination, File file) {
    _upload();
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      _uploading = false;
      notifyListeners();
      return ref.putFile(file);
    } on FirebaseException catch (_) {
      _uploading = false;
      notifyListeners();
      return null;
    }
  }

  bool _fileDownloaded = false;
  bool get fileDownloaded => _fileDownloaded;

  Future<void> downloadFile(Reference ref, String pathName) async {
    debugPrint('Downloading file ...');
    final path = await getApplicationDocumentsDirectory();
    final filePath = '${path.path}/$pathName';
    final file = File(filePath);
    debugPrint('Downloading file to ${path.absolute}/$pathName');
    debugPrint('${ref.getDownloadURL()}');
    try {
      await ref.writeToFile(file);
      debugPrint('File downloaded');
      _fileDownloaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Download failed : ${e.toString()}');
    }
  }
}
