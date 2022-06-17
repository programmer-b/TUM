import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tum/Widgets/widgets.dart';

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
