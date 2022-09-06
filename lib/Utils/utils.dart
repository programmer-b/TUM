import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/parser.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:tum/Constants/constants.dart';
import 'package:tum/Firebase/firebase.dart';
import 'package:tum/UI/auth/auth.dart';
import 'package:tum/UI/home/home.dart';
import 'package:tum/UI/home/pdf_viewer_page.dart';

import '../Widgets/widgets.dart';

part './dialogs.dart';
part './messengers.dart';
part './operations.dart';
part './counter_storage.dart';
part './icons_helper.dart';
part './notifications.dart';
part './internet_checker.dart';
part 'admobservice.dart';

extension E on String {
  String lastChars(int n) => substring(length - n);
}

extension MyDateExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }
}

String pdfFileName(String url) {
  String name = basename(url);
  return name;
  // return url.substring(url.indexOf('=') + 1, url.length - 1);
}

Future<void> signOut(context) async {
  await PageDialog.yesOrNoDialog(
      context, 'Logout', 'Do you wish to logout this account?',
      onPressed: () async {
    await context.read<FirebaseAuthProvider>().logOut();
    Navigator.pop(context);

    toast('Logged out successfully');
    const LoginScreen().launch(context,
        pageRouteAnimation: PageRouteAnimation.Rotate, isNewTask: true);
  });
}

void openPDF(
  context,
  String url,
  String title,
) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PDFScreen(url: url, title: title)));

void openNews(context, String url, String title, String image) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsPage(url: url, title: title, image: image)));

Future<T?> pushPage<T>(BuildContext context, Widget page) {
  return Navigator.of(context)
      .push<T>(MaterialPageRoute(builder: (context) => page));
}

void launchBrowser(Uri uri) {
  // html.window.open(uri.toString(), '_blank');
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    log('This permission is granted');
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  log('Permission denied');
  return false;
}

initFlutterDownloader() async {
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to
      );
}
