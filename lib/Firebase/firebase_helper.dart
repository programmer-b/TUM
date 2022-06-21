part of 'package:tum/Firebase/firebase.dart';

class FirebaseHelper with ChangeNotifier {
  static DatabaseReference userRef =
      FirebaseDatabase.instance.ref('Users/Students/${userId()}');
  final User? user = FirebaseAuth.instance.currentUser;

  bool _success = false;
  bool _error = false;

  bool get success => _success;
  bool get error => _error;

  bool _loading = false;
  bool get loading => _loading;

  _load() {
    _loading = true;
    notifyListeners();
  }

  void init() {
    _success = false;
    _error = false;
    notifyListeners();
  }

  Future<void> update(Map<String, Object?> map) async {
    try {
      _load();
      await userRef.update(map);
      _success = true;
    } on FirebaseException catch (_) {
      _error = true;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> write(Map<String, Object?> map) async {
    try {
      _load();
      await userRef.set(map);
      _success = true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      _error = true;
    }
    _loading = false;
    notifyListeners();
  }

  DatabaseEvent? _event;
  DatabaseEvent? get event => _event;

  void read() {
    userRef.onValue.listen((event) {
      _event = event;
      notifyListeners();
    });
  }

  Future<bool> rootFirebaseIsExists() async {
    final uid = user!.uid;

    DatabaseEvent event =
        await FirebaseDatabase.instance.ref('Users/Students/$uid').once();

    return event.snapshot.value != null;
  }

  Future<bool> shouldMigrate() async {
    final uid = user!.uid;

    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('Users/Students/$uid')
        .child('fullName')
        .once();

    return event.snapshot.value != null;
  }
}
