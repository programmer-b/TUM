import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tum/Utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tum/Constants/constants.dart';
import 'package:tum/Firebase/firebase.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

part './theme_provider.dart';
part 'tum_state.dart';
part './api.dart';

FirebaseHelper helper = FirebaseHelper();

final notify = NotificationsApi();
final storage = CounterStorage();
final dialog = PageDialog();
final messenger = Messenger();
