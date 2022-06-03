part of 'package:tum/Firebase/firebase.dart';

class FirebaseHelper {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('Users/Students/${userId()}');

  Future<void> update(Map<String, Object?> map) async {
    await ref.update(map);
  }
}

String userId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user!.uid.toString();
}
