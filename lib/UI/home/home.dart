import 'dart:developer';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:html/dom.dart' as dom;
//import 'package:html/parser.dart' show parse;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:tum/Constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:tum/Models/models.dart';
//import 'package:tum/UI/home/pdf_viewer_page.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/Widgets/widgets.dart';
import 'package:tum/provider/provider.dart';

import '../../Firebase/firebase.dart';

part './dashboard.dart';
part './news_page.dart';
part './calender.dart';
part './eduroam.dart';
part './elearning.dart';
part './eregister.dart';
part './news.dart';
part './settings.dart';
part './pastpapers.dart';
part './downloads.dart';
part './portal_welcome_screen.dart';

dom.Document _dataHtml(String html) {
  return dom.Document.html(html);
}

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
final Messenger messanger = Messenger();

final PageDialog dialog = PageDialog();

DatabaseReference dataRef = FirebaseDatabase.instance.ref('Data');

List<String?> urls = [];
String noticeBoard = '';
String news = '';
String downloads = '';
Applications applications = Applications();

EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 20);

final API api = API();

int notifications = 3;

List<String> urlImages = [];
List<NoticeBoardData> noticeBoardData = [];
List<NewsData> newsdata = [];

Widget homeNoticeBoard(context,
    {required List<NoticeBoardData> noticeBoardData, required int length}) {
  bool noticeIsExpanded = true;
  final themeProvider = Provider.of<ThemeProvider>(context);
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
            TxtButton(
              text: 'read more',
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              onPressed: () {},
            )
          ],
        ),
      ),
    ),
  );
}

Widget homeDownloadsBoard(context,
    {required List<DownloadsData> downloadsData, required int length}) {
  bool noticeIsExpanded = true;
  final themeProvider = Provider.of<ThemeProvider>(context);
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
            TxtButton(
              text: 'read more',
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              onPressed: () {},
            )
          ],
        ),
      ),
    ),
  );
}

Widget homeNewsBoard(context,
    {required List<NewsData> newsdata, required int length}) {
  bool newsIsExpanded = true;
  final themeProvider = Provider.of<ThemeProvider>(context);
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
          initiallyExpanded: newsIsExpanded,
          onExpansionChanged: (expanded) {},
          title: const Txt(
            text: ' tum news',
            fullUpperCase: true,
          ),
          children: [
            for (int i = 0; i < length; i++) newsChild(i),
            TxtButton(
              text: 'read more',
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              onPressed: () {},
            )
          ],
        ),
      ),
    ),
  );
}
