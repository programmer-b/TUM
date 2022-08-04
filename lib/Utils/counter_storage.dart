part of 'package:tum/Utils/utils.dart';

class CounterStorage with ChangeNotifier {
  Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile(String name) async {
    final path = await localPath();
    return File('$path/$name');
  }

  Future<Uint8List?> readFile(String name) async {
    try {
      final file = await localFile(name);
      final contents = await file.readAsBytes();
      return contents;
    } catch (_) {
      return null;
    }
  }

  Future<bool> directoryExists(String name) async {
    String path = await localPath();

    bool fileExists = await File("$path/$name").exists();
    bool exists = fileExists;
    return exists;
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      log("error while renaming file: $e");
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPath.downloadsDirectory();
    }
    return getApplicationDocumentsDirectory();
  }
}
