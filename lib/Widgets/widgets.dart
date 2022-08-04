import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tum/Constants/constants.dart';
import 'package:tum/UI/home/pdf_viewer_page.dart';
import 'package:tum/Utils/utils.dart';

import '../Firebase/firebase.dart';
import '../UI/home/home.dart';
import '../provider/provider.dart';

part 'Buttons/back_button.dart';
part './my_text_field.dart';
part './txt.dart';
part './change_theme_button_widget.dart';
part 'Buttons/text_button.dart';
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
part './shimmer_widget.dart';
part './Browser/tum_web.dart';
part 'AppBars/custom_page_appbar.dart';
part './Browser/web_navigation.dart';
part './Browser/browser_search_bar.dart';

final CounterStorage counterStorage = CounterStorage();

Widget downloadProgress() =>
    const ShimmerWidget.rectangular(width: double.infinity, height: 200);
Widget imageDownloadError() => const Center(
      child: Txt(text: 'Something went wrong'),
    );
final dialog = PageDialog();

Widget buildImage(String urlImage) {
  final url = urlImage;
  const double height = 200;
  return CachedNetworkImage(
    //placeholder: (_, __) => downloadProgress(),
    progressIndicatorBuilder: (_, __, ___) => downloadProgress(),
    key: UniqueKey(),
    width: double.infinity,
    fit: BoxFit.cover,
    height: height,
    imageUrl: url,
  );
}

Widget buildNewsImage(String url) {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    child: CachedNetworkImage(
      placeholder: (_, __) {
        return const ShimmerWidget.circular(
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            width: double.infinity,
            height: 100);
      },
      errorWidget: (_, __, ___) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.error, color: Colors.red),
              SizedBox(height: 10),
              Txt(text: 'Internet error')
            ],
          ),
        );
      },
      width: double.infinity,
      height: 100,
      key: UniqueKey(),
      fit: BoxFit.cover,
      imageUrl: url,
    ),
  );
}
