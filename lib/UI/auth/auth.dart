import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Constants/constants.dart';
import '../../Firebase/firebase.dart';
import '../../Utils/utils.dart';
import '../../Widgets/widgets.dart';
import '../../provider/provider.dart';
part './login_screen.dart';
part './forgot_password_screen.dart';
part './register_screen.dart';
part './check_email.dart';

final PageDialog dialog = PageDialog();
final FieldForm formField = FieldForm();

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.grey[200],
        statusBarIconBrightness: context.read<ThemeProvider>().isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ));
}
