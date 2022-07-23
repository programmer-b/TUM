part of 'package:tum/UI/home/home.dart';

class Eregister extends StatefulWidget {
  const Eregister({ Key? key }) : super(key: key);

  @override
  State<Eregister> createState() => _EregisterState();
}

class _EregisterState extends State<Eregister> {
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
        title: const Txt(text: "Eregister"));
  }
}