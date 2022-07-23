part of 'package:tum/UI/home/home.dart';

class PastPapers extends StatefulWidget {
  const PastPapers({ Key? key }) : super(key: key);

  @override
  State<PastPapers> createState() => _PastPapersState();
}

class _PastPapersState extends State<PastPapers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: const MyDrawer(),
    );
  }

   PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        actions: [
         
          MyIconButton(
            icon: Icons.more_vert,
            onPressed: () {},
            toolTip: "More options",
          )
        ],
        title: const Txt(text: "Home"));
  }
}