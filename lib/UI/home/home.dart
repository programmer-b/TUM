import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part './dashboard.dart';

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
      
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
      ));
}