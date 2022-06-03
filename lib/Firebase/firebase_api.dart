part of 'package:tum/Firebase/firebase.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      return ref.putFile(file);
    } on FirebaseException catch (_) {
      return null;
    }
  }
}
