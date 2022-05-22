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
  UserCredential? _credential;

  String get emailError => _emailError;
  String get passwordError => _passwordError;
  bool get dataError => _dataError;
  bool get catchError => _catchError;
  bool get success => _success;
  bool get error => _error;
  String get errorMessage => _errorMessage;
  UserCredential? get credential => _credential;

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
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      _credential = userCredential;
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
