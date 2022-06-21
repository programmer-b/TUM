import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tum/UI/auth/auth.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/Constants/constants.dart';
import '../../Widgets/widgets.dart';
import 'package:tum/Firebase/firebase.dart';

part './setup_screen.dart';
part './migrate_to_flutter.dart';

final Messenger messenger = Messenger();
final Operations operations = Operations();
final PageDialog dialog = PageDialog();
final FirebaseHelper helper = FirebaseHelper();





