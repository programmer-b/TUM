import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

part './firebase_helper.dart';
part './firebase_api.dart';
part './firebase_auth_provider.dart';

User? user = FirebaseAuth.instance.currentUser;

userId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return null;
  } else {
    return user.uid;
  }
}
