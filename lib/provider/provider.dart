import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tum/Constants/constants.dart';
import 'package:tum/Firebase/firebase.dart';
import 'package:http/http.dart' as http;

part './theme_provider.dart';
part 'tum_state.dart';
part './api.dart';

FirebaseHelper helper = FirebaseHelper();
