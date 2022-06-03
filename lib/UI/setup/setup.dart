import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/Constants/constants.dart';
import '../../Widgets/widgets.dart';

part './setup_screen.dart';

final Messenger messenger = Messenger();
final Operations operations = Operations();