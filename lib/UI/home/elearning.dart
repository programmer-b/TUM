part of 'package:tum/UI/home/home.dart';

class Elearning extends StatefulWidget {
  const Elearning({ Key? key }) : super(key: key);

  @override
  State<Elearning> createState() => _ElearningState();
}

class _ElearningState extends State<Elearning> {
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