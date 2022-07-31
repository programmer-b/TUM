part of 'package:tum/Constants/constants.dart';

class Urls {
  static const String avatar1 =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKPfgzu_mQU02o2kX5rn0hMGU8MQKpHsHdGQ&usqp=CAU";

  static const String tumHome = 'https://www.tum.ac.ke';
  static String tumNoticeBoard(int page) {
    return '$tumHome/noticeboard/index?page=$page';
  }

  static String tumNews(int page) {
    return '$tumHome/news/index?page=$page';
  }

  static String tumDownloads(int page) {
    return '$tumHome/downloads/admission?page=$page';
  }
}
