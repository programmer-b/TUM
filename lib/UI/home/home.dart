
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tum/Constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:tum/Models/models.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/Widgets/widgets.dart';
import 'package:tum/provider/provider.dart';

import '../../Firebase/firebase.dart';

part './dashboard.dart';

PreferredSizeWidget appBar(BuildContext context,
    {Color statusBarColor = Colors.transparent,
    Color? backgroundColor,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Widget? title,
    bool? centerTitle,
    List<Widget>? actions}) {
  return AppBar(
      centerTitle: centerTitle,
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: Brightness.light));
}

final Operations operations = Operations();

DatabaseReference dataRef =
        FirebaseDatabase.instance.ref('Data');
