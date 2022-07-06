part of 'package:tum/Firebase/firebase.dart';

class FirebaseHelper with ChangeNotifier {
  static DatabaseReference userRef =
      FirebaseDatabase.instance.ref('Users/Students/${userId()}');
  static DatabaseReference rootRef = FirebaseDatabase.instance.ref('Data');
  // final User? user = FirebaseAuth.instance.currentUser;

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

  Future<void> updateToCustomPath(Map<String, Object?> map,
      {String path = "Data"}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    try {
      _load();
      log("upadating map to custom path");
      await ref.update(map);
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

  DatabaseEvent? _homeEvent;
  DatabaseEvent? get home => _homeEvent;

  DatabaseEvent? _rootEvent;
  DatabaseEvent? get root => _rootEvent;

  void read() {
    userRef.onValue.listen((event) {
      _homeEvent = event;
      notifyListeners();
    });
    rootRef.onValue.listen((event) {
      _rootEvent = event;
      notifyListeners();
    });
  }

  Future<bool> rootFirebaseIsExists() async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('Users/Students/${userId()}')
        .once();

    return event.snapshot.value != null;
  }

  Future<bool> shouldMigrate() async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('Users/Students/${userId()}')
        .child('fullName')
        .once();

    return event.snapshot.value != null;
  }

  List _apps = [];
  List get apps => _apps;

  void readMenu() {
    final applications = FirebaseDatabase.instance.ref('/Data/Applications');

    applications.onValue.listen((DatabaseEvent event) {
      _apps = jsonDecode(jsonEncode(event.snapshot.value));
      notifyListeners();
    });
  }
}
