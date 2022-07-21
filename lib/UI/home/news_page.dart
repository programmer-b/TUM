part of 'package:tum/UI/home/home.dart';

class NewsPage extends StatefulWidget {
  final String title;
  final String image;
  final String url;
  const NewsPage(
      {Key? key, required this.title, required this.image, required this.url})
      : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(text: widget.title, upperCaseFirst: true,),
      
      ),
    );
  }
}
