import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tum/Constants/constants.dart';
import 'package:tum/Utils/utils.dart';

import '../Firebase/firebase.dart';
import '../provider/provider.dart';

part 'Buttons/back_button.dart';
part './my_text_field.dart';
part './txt.dart';
part './change_theme_button_widget.dart';
part './text_button.dart';
part 'Buttons/my_button.dart.dart';
part 'logo.dart';
part './form_fields.dart';
part './auth_header.dart';
part './icon_widget.dart';
part 'Avatars/setup_avatar.dart';
part 'Indicators/progress_indicator.dart';
part './Indicators/button_indicator.dart';
part './Buttons/my_icon_button.dart';
part './Drawer/my_drawer.dart';
part './Drawer/drawer_header.dart';
part './Errors/error_retry.dart';
part './Avatars/user_avatar.dart';
part './Buttons/application_button.dart';
part './scrollable_widget.dart';
part './Buttons/application_icon_button.dart';
part './Buttons/custom_icon_button.dart';

final CounterStorage counterStorage = CounterStorage();
