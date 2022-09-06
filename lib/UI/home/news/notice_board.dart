part of 'package:tum/UI/home/home.dart';

class NoticeBoard extends StatelessWidget {
  const NoticeBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableWidget(
      child: homeNoticeBoard(context,
          noticeBoardData: noticeBoardData,
          length: noticeBoardData.length,
          readmore: false),
    );
  }
}
