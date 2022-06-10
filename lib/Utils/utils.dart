import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../Widgets/widgets.dart';

part './dialogs.dart';
part './messengers.dart';
part './operations.dart';

extension E on String {
  String lastChars(int n) => substring(length - n);
}

extension MyDateExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }
}
