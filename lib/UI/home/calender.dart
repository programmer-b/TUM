part of 'package:tum/UI/home/home.dart';

class Calender extends StatefulWidget {
  const Calender({ Key? key }) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
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