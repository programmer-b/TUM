part of 'package:tum/UI/home/home.dart';

class NewsContent extends StatelessWidget {
  const NewsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableWidget(child: homeNewsBoard(context, newsdata: newsData, length: newsData.length, readmore: false));
  }
}
