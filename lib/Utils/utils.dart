import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:tum/UI/home/home.dart';
import 'package:tum/UI/home/pdf_viewer_page.dart';
import '../Widgets/widgets.dart';

part './dialogs.dart';
part './messengers.dart';
part './operations.dart';
part 'counter_storage.dart';
part './icons_helper.dart';

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
void openPDF(
    context,
    String url,
    String title,
  ) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PDFScreen(url: url, title: title)));

  void openNews(context, String url, String title, String image) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              NewsPage(url: url, title: title, image: image)));