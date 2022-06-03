part of 'package:tum/Firebase/firebase.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  String _emailError = '';
  String _passwordError = '';
  bool _dataError = false;
  bool _catchError = false;
  bool _success = false;
  bool _error = false;
  String _errorMessage = '';
  String _userId = '';
  UserCredential? _credential;

  String get emailError => _emailError;
  String get passwordError => _passwordError;
  bool get dataError => _dataError;
  bool get catchError => _catchError;
  bool get success => _success;
  bool get error => _error;
  String get errorMessage => _errorMessage;
  String get userId => _userId;
  UserCredential? get credential => _credential;

  user() {
    User? user = FirebaseAuth.instance.currentUser;
    _userId = user!.uid.toString();
    notifyListeners();
  }

  uid() {
    user();
    return _userId;
  }

  void init() {
    _emailError = '';
    _passwordError = '';
    _dataError = false;
    _catchError = false;
    _success = false;
    _error = false;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      await Auth.instance.signIn(email: email, password: password);
      _success = true;
    } on FirebaseAuthException catch (exception) {
      debugPrint(exception.toString());
      _dataError = true;

      _determineError(exception);
    } catch (exception) {
      debugPrint(exception.toString());

      _catchError = true;
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _credential = userCredential;
      _success = true;
    } on FirebaseAuthException catch (exception) {
      _dataError = true;

      _determineError(exception);
    } catch (exception) {
      _catchError = true;
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      debugPrint('start');
      await auth.sendPasswordResetEmail(email: email);
      debugPrint('end');
      _success = true;
    } on FirebaseAuthException catch (exception) {
      _dataError = true;

      _determineError(exception);
    } catch (exception) {
      _catchError = true;
    }
    notifyListeners();
  }

  _determineError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        _emailError = 'Your email is invalid.';
        break;
      case 'user-disabled':
        _passwordError = 'Your user account has been disabled';
        break;
      case 'user-not-found':
        _emailError = 'Couldn\'t find your email account.';
        break;
      case 'wrong-password':
        _passwordError =
            'Wrong password. Try again or click Forgot password \nto reset it.';
        break;
      case 'email-already-in-use':
        _emailError = 'This email already exists.';
        break;
      case 'account-exists-with-different-credential':
      case 'invalid-credential':
      case 'operation-not-allowed':
      case 'weak-password':
        _passwordError = 'This password is too weak';
        break;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        {
          _catchError = true;
          _errorMessage = 'Oops... Check your connection and try again';
        }
    }
  }
}

class Auth {
  static final instance = Auth._();
  Auth._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool get isSignedIn => _auth.currentUser != null;

  Stream<User?> authStateChange() => _auth.authStateChanges();

  Future<void> signIn({required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();
}
