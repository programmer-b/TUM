// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_inappwebview/src/in_app_webview/in_app_webview_controller.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
//import 'package:html/parser.dart' show parse;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:open_file/open_file.dart';
import 'package:tum/Constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:tum/Models/models.dart';
// import 'package:tum/UI/auth/auth.dart';
// import 'package:tum/UI/home/pdf_viewer_page.dart' hide storage;
//import 'package:tum/UI/home/pdf_viewer_page.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/Widgets/widgets.dart';
import 'package:tum/provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Firebase/firebase.dart';

part './dashboard.dart';
part './news_page.dart';
part './calender.dart';
part './eduroam.dart';
part './elearning.dart';
part './eregister.dart';
part './news/news.dart';
part './settings/settings.dart';
part './pastpapers.dart';
part './downloads.dart';
part './portal_welcome_screen.dart';
part './news/news_content.dart';
part './news/notice_board.dart';
part './settings/account_page.dart';
part './settings/elearning_settings.dart';
part './settings/eregister_settings.dart';
part './settings/report_bug.dart';
part './settings/send_feedback.dart';
part './settings/update_account_info.dart';
part './notifications/notifications_data.dart';
part './notifications/reminder_data.dart';

dom.Document _dataHtml(String html) {
  return dom.Document.html(html);
}

final messenger = Messenger();
PreferredSizeWidget appBar(BuildContext context,
    {Color statusBarColor = Colors.transparent,
    Color? backgroundColor,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Widget? title,
    bool? centerTitle,
    PreferredSizeWidget? bottom,
    List<Widget>? actions}) {
  return AppBar(
      bottom: bottom,
      centerTitle: centerTitle,
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
          // statusBarColor: statusBarColor,
          statusBarIconBrightness: Brightness.light));
}

final Operations operations = Operations();
final Messenger messanger = Messenger();

final PageDialog dialog = PageDialog();

DatabaseReference dataRef = FirebaseDatabase.instance.ref('Data');

List<String?> urls = [];
String dashboardImages = '';
String noticeBoard = '';
String news = '';
String downloads = '';
Applications applications = Applications();

EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 20);

final API api = API();

int notifications = 3;

List<String> urlImages = [];
List<NoticeBoardData> noticeBoardData = [];
List<NewsData> newsData = [];
List<DownloadsData> downloadsData = [];


Widget homeNoticeBoard(context,
    {required List<NoticeBoardData> noticeBoardData,
    required int length,
    bool readmore = true}) {
  bool noticeIsExpanded = true;
  final themeProvider = Provider.of<ThemeProvider>(context);
  final myProvider = Provider.of<TUMState>(context);
  Widget noticeChild(int i) {
    void onTap(context) {
      openPDF(context, noticeBoardData[i].url!, noticeBoardData[i].notice!);
    }

    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: () async => onTap(context),
          leading: Txt(text: i + 1),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Txt(
              text: noticeBoardData[i].notice,
              upperCaseFirst: true,
              textAlign: TextAlign.start,
              color: themeProvider.isDarkMode ? null : Colors.black,
            ),
          ),
          horizontalTitleGap: 0,
          subtitle: Txt(
            text: noticeBoardData[i].date,
            textAlign: TextAlign.start,
            fullUpperCase: true,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            color: themeProvider.isDarkMode ? Colors.white70 : null,
            onPressed: () async => onTap(context),
          ),
        ),
        const Divider()
      ],
    );
  }

  // log('expanded: $noticeIsExpanded');
  return Container(
    padding: padding,
    child: ListTileTheme(
      dense: true,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: const Color.fromRGBO(196, 196, 196, 0.6),
          unselectedWidgetColor: themeProvider.isDarkMode
              ? Colors.white
              : Colors.black54, // here for close state
          colorScheme: ColorScheme.light(
            primary:
                themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen,
          ),
        ), //
        child: ExpansionTile(
          initiallyExpanded: noticeIsExpanded,
          onExpansionChanged: (expanded) {},
          title: const Txt(
            text: 'notice board',
            fullUpperCase: true,
          ),
          children: [
            for (int i = 0; i < length; i++) noticeChild(i),
            if (readmore)
              TxtButton(
                textColor: Colorz.primaryGreen,
                text: 'read more',
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                onPressed: () =>
                    myProvider.navidateToScreen(context, '/news', 4),
              )
          ],
        ),
      ),
    ),
  );
}

Widget homeDownloadsBoard(context,
    {required List<DownloadsData> downloadsData,
    required int length,
    bool readmore = true}) {
  bool noticeIsExpanded = true;
  final themeProvider = Provider.of<ThemeProvider>(context);
  final myProvider = Provider.of<TUMState>(context);
  Widget noticeChild(int i) {
    void onTap(context) {
      openPDF(context, downloadsData[i].url!, downloadsData[i].title!);
    }

    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: () async => onTap(context),
          leading: Txt(text: i + 1),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Txt(
              text: downloadsData[i].title,
              upperCaseFirst: true,
              textAlign: TextAlign.start,
              color: themeProvider.isDarkMode ? null : Colors.black,
            ),
          ),
          horizontalTitleGap: 0,
          // subtitle: Txt(
          //   text: noticeBoardData[i].date,
          //   textAlign: TextAlign.start,
          //   fullUpperCase: true,
          // ),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            color: themeProvider.isDarkMode ? Colors.white70 : null,
            onPressed: () async => onTap(context),
          ),
        ),
        const Divider()
      ],
    );
  }

  // log('expanded: $noticeIsExpanded');
  return Container(
    padding: padding,
    child: ListTileTheme(
      dense: true,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: const Color.fromRGBO(196, 196, 196, 0.6),
          unselectedWidgetColor: themeProvider.isDarkMode
              ? Colors.white
              : Colors.black54, // here for close state
          colorScheme: ColorScheme.light(
            primary:
                themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen,
          ),
        ), //
        child: ExpansionTile(
          initiallyExpanded: noticeIsExpanded,
          onExpansionChanged: (expanded) {},
          title: const Txt(
            text: 'tum downloads',
            fullUpperCase: true,
          ),
          children: [
            for (int i = 0; i < length; i++) noticeChild(i),
            if (readmore)
              TxtButton(
                textColor: Colorz.primaryGreen,
                text: 'read more',
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                onPressed: () =>
                    myProvider.navidateToScreen(context, '/downloads', 6),
              )
          ],
        ),
      ),
    ),
  );
}

Widget homeNewsBoard(context,
    {required List<NewsData> newsdata,
    required int length,
    bool readmore = true}) {
  bool newsIsExpanded = true;
  final themeProvider = Provider.of<ThemeProvider>(context);
  final myProvider = Provider.of<TUMState>(context);
  Widget newsChild(int i) {
    void onTap(context) {
      openNews(
          context, newsdata[i].url!, newsdata[i].news!, newsdata[i].image!);
    }

    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: () async => onTap(context),
          leading: Txt(text: i + 1),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNewsImage(newsdata[i].image!),
                const SizedBox(
                  height: 6,
                ),
                Txt(
                  text: newsdata[i].news,
                  upperCaseFirst: true,
                  textAlign: TextAlign.start,
                  color: themeProvider.isDarkMode ? null : Colors.black,
                ),
              ],
            ),
          ),
          horizontalTitleGap: 0,
          subtitle: Txt(
            text: newsdata[i].date,
            textAlign: TextAlign.start,
            fullUpperCase: true,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            color: themeProvider.isDarkMode ? Colors.white70 : null,
            onPressed: () => myProvider.navidateToScreen(context, '/news', 4),
          ),
        ),
        const Divider()
      ],
    );
  }

  // log('expanded: $noticeIsExpanded');
  return Container(
    padding: padding,
    child: ListTileTheme(
      dense: true,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: const Color.fromRGBO(196, 196, 196, 0.6),
          unselectedWidgetColor: themeProvider.isDarkMode
              ? Colors.white
              : Colors.black54, // here for close state
          colorScheme: ColorScheme.light(
            primary:
                themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen,
          ),
        ), //
        child: ExpansionTile(
          initiallyExpanded: newsIsExpanded,
          onExpansionChanged: (expanded) {},
          title: const Txt(
            text: ' tum news',
            fullUpperCase: true,
          ),
          children: [
            for (int i = 0; i < length; i++) newsChild(i),
            if (readmore)
              TxtButton(
                textColor: Colorz.primaryGreen,
                text: 'read more',
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                onPressed: () => myProvider.navidateToScreen(context, '/news', 4)
              )
          ],
        ),
      ),
    ),
  );
}
