import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tum/Constants/constants.dart';
import '../Widgets/widgets.dart';

part './dialogs.dart';
part './messengers.dart';
part './operations.dart';

extension E on String {
  String lastChars(int n) => substring(length - n);
}