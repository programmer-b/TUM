part of 'package:tum/Firebase/firebase.dart';

class FirebaseHelper with ChangeNotifier {
  DatabaseReference userRef =
      FirebaseDatabase.instance.ref('Users/Students/${userId()}');
  DatabaseReference adminRef =
      FirebaseDatabase.instance.ref('Data/Admin');

  bool _success = false;
  bool _error = false;

  bool get success => _success;
  bool get error => _error;

  void init() {
    _success = false;
    _error = false;
    notifyListeners();
  }

  Future<void> updateUser(Map<String, Object?> map) async {
    try {
      await userRef.update(map);
      _success = true;
    } on FirebaseException catch (_) {
      _error = true;
    }
    notifyListeners();
  }

  Future<void> updateAdmin(Map<String, Object?> map) async {
    try {
      await userRef.update(map);
      _success = true;
    } on FirebaseException catch (_) {
      _error = true;
    }
    notifyListeners();
  }

  Future<bool> rootFirebaseIsExists() async {
    DatabaseEvent event = await userRef.once();

    return event.snapshot.value != null;
  }
}


